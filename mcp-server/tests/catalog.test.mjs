import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync, writeFileSync, existsSync, mkdtempSync, symlinkSync, rmSync } from 'node:fs';
import { resolve, dirname, join } from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';
import { tmpdir } from 'node:os';
import { execFileSync } from 'node:child_process';
import { Client } from '@modelcontextprotocol/sdk/client/index.js';
import { StdioClientTransport } from '@modelcontextprotocol/sdk/client/stdio.js';
import { validateSpacing, validateRadius } from '../dist/tools/validate.js';
import { tokensData, componentsData, lookupComponent } from '../dist/tools/lookup.js';
import { planMigration } from '../dist/tools/migrate.js';

const root = resolve(dirname(fileURLToPath(import.meta.url)), '..');

test('all named Swift spacing tokens are accepted by lookup and validation', () => {
  const swift = readFileSync(join(root, '../Sources/LubaCore/Tokens/LubaSpacing.swift'), 'utf8');
  for (const [, name, value] of swift.matchAll(/public static let (\w+): CGFloat = (\d+)\b/g)) {
    assert.ok(tokensData.spacing.tokens.some(t => t.name === name && t.value === Number(value)), name);
    assert.equal(validateSpacing(Number(value)).token.name, name);
    assert.equal(validateSpacing(Number(value)).valid, true);
    const migration = planMigration('Example', { spacing: [{ name, value: Number(value) }] });
    assert.equal(migration.spacingMappings[0].lubaUI.api, `LubaSpacing.${name}`);
    assert.equal(migration.spacingMappings[0].lubaUI.match, 'exact');
  }
  assert.equal(validateSpacing(2).onGrid, false, 'xxs is deliberately half-grid');
  assert.equal(validateSpacing(14).valid, false);
  for (const token of tokensData.radius.tokens) assert.equal(validateRadius(token.value).valid, true);
});

test('the 0.3 catalog retires charts and explains migration', () => {
  assert.ok(!componentsData.some(c => /Chart|Sparkline/.test(c.name)));
  const result = lookupComponent('LubaBarChart');
  assert.equal(result.found, false);
  assert.match(result.message, /removed in 0.3.0/);
  assert.match(result.message, /Swift Charts/);
});

test('the publishable archive works outside the source checkout', async (t) => {
  const temp = mkdtempSync(join(tmpdir(), 'lubaui-package-test-'));
  let client;
  try {
    const pack = JSON.parse(execFileSync('npm', ['pack', '--json', '--ignore-scripts', '--pack-destination', temp], { cwd: root, encoding: 'utf8' }))[0];
    for (const { path } of pack.files) {
      assert.match(path, /^(?:package\.json|README\.md|LICENSE|bin\/lubaui-mcp\.js|dist\/[\w/.-]+\.(?:js|d\.ts)|src\/data\/[\w-]+\.json)$/,
        `Unexpected published file: ${path}`);
    }
    execFileSync('tar', ['-xzf', join(temp, pack.filename), '-C', temp]);
    const installed = join(temp, 'package');
    assert.deepEqual(readFileSync(join(installed, 'LICENSE')), readFileSync(join(root, '../LICENSE')),
      'The published archive must carry the library license and attribution');
    symlinkSync(join(root, 'node_modules'), join(installed, 'node_modules'), 'dir');
    for (const file of ['tokens.json', 'components.json', 'primitives.json']) {
      assert.deepEqual(readFileSync(join(installed, 'src/data', file)), readFileSync(join(root, 'src/data', file)));
    }
    client = new Client({ name: 'catalog-regression', version: '1.0.0' });
    await client.connect(new StdioClientTransport({ command: process.execPath, args: [join(installed, 'bin/lubaui-mcp.js')], cwd: temp }));
    const reference = JSON.parse((await client.readResource({ uri: 'lubaui://reference/full' })).contents[0].text);
    assert.equal(reference.version, JSON.parse(readFileSync(join(root, 'package.json'), 'utf8')).version);
    assert.equal(reference.components.length, componentsData.length);
    assert.equal(reference.libraryVersion, "0.3.0");
    assert.equal(reference.libraryStatus, "released");
    assert.deepEqual(reference.products, ["LubaCore", "LubaComponents", "LubaUI"]);
    assert.match(JSON.stringify(reference.architecture), /LubaEnvironment/);
    assert.match(reference.tokens.typography.description, /Dynamic Type/);
    const result = await client.callTool({ name: 'validate_spacing', arguments: { value: 2 } });
    assert.equal(JSON.parse(result.content[0].text).token.api, 'LubaSpacing.xxs');
    assert.equal((await client.listTools()).tools.length, 10);

    await t.test('rejects malformed and oversized inputs, then accepts a valid request', async () => {
      const invalid = [
        { name: 'lookup_token', arguments: { query: 'x'.repeat(201) } },
        { name: 'lookup_components', arguments: { queries: Array(26).fill('Button') } },
        { name: 'lookup_tokens', arguments: { queries: Array(51).fill('spacing') } },
        { name: 'validate_spacing', arguments: { value: null } },
        { name: 'validate_radius', arguments: { value: 'Infinity' } },
        { name: 'suggest_tokens', arguments: { description: 'x'.repeat(501) } },
        { name: 'plan_migration', arguments: { source_system: 'Example', colors: [{ name: 'invalid', value: '#FFzz00' }] } },
        { name: 'plan_migration', arguments: { source_system: 'Example', spacing: Array(101).fill({ name: 'gap', value: 2 }) } },
      ];
      for (const request of invalid) {
        const response = await client.callTool(request);
        assert.equal(response.isError, true, `${request.name} must reject invalid input`);
      }
      const valid = await client.callTool({ name: 'plan_migration', arguments: { source_system: 'Example', spacing: [{ name: 'gap', value: 2 }] } });
      assert.equal(JSON.parse(valid.content[0].text).spacingMappings[0].lubaUI.api, 'LubaSpacing.xxs');
    });

    await t.test('queries and resource URIs cannot read neighboring files or run commands', async () => {
      const canary = join(temp, 'private-canary.txt');
      const marker = join(temp, 'command-executed');
      const privateText = 'PRIVATE_CANARY_CONTENT_DO_NOT_RETURN';
      writeFileSync(canary, privateText);
      const queries = ['../private-canary.txt', canary, `$(touch ${marker})`, `; touch ${marker}`];
      for (const query of queries) {
        const response = await client.callTool({ name: 'lookup_token', arguments: { query } });
        assert.ok(!JSON.stringify(response).includes(privateText));
      }
      for (const uri of [pathToFileURL(canary).href, 'lubaui://reference/../../private-canary.txt']) {
        await assert.rejects(client.readResource({ uri }), /not found|unknown/i);
      }
      assert.equal(existsSync(marker), false, 'Input must never be passed to a shell');
      assert.equal(readFileSync(canary, 'utf8'), privateText);
      assert.equal((await client.listTools()).tools.length, 10, 'Server remains usable');
    });
  } finally {
    if (client) await client.close();
    rmSync(temp, { recursive: true, force: true });
  }
});
