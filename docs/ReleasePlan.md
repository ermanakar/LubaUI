# Release procedure

This procedure covers LubaUI **0.3.0** and MCP **1.4.0**. It is a maintainer
checklist, not a record of publication status. Verify GitHub releases and the
npm registry for the published artifacts.

## Release scope

- **LubaCore** supplies tokens, themes, configuration, motion, accessibility,
  localization, and interaction primitives without the component catalog.
- **LubaComponents** adds ready-made views and re-exports Core.
- **LubaUI** re-exports both, preserving existing non-chart source imports.
- Chart wrappers, protocols, layout tokens, and styling are removed. Existing
  theme color helpers remain; no library target imports Apple's Charts framework.
- Configuration inheritance, chip actions, touch targets, growing text fields,
  and subtree haptic behavior are corrected.
- The README and website show real interface examples with attribution notes.
  They contain no App Store link or app download promotion.

Read the [migration guide](MigratingTo0.3.md) and [changelog](../CHANGELOG.md)
for breaking chart removals and behavior changes. Module separation does not
establish a particular reduction in final application binary size.

## Release checks

- [ ] Review the final source and run CI on its exact commit, including the
  older pinned Xcode toolchain, Swift tests, downstream consumers, iOS build,
  documented example, and packed MCP tests.
- [ ] Validate a real application against the candidate using a local package
  override. Keep its shipping dependency unchanged until that upgrade is reviewed.
- [ ] Build DocC and check README links, the mobile/desktop website, screenshot
  attribution, product names, and version labels.
- [ ] Scan the public source tree, reachable Git history, and npm archive for
  credentials; run the dependency audit and adversarial MCP tests.
- [ ] Confirm GitHub secret scanning, push protection, dependency security
  updates, and private vulnerability reporting are enabled in repository settings.
- [ ] Review the remaining public identity: the repository owner, Git history,
  and preserved license attribution are public even though demo and promotional
  copy do not foreground a personal name.

Local test logs, private application baselines, and review notes belong outside
the public release assets. CI and application validation are evidence for the
checked configurations, not a claim that every Apple platform or assistive
technology has been fully audited.

## Publication sequence

1. Commit and push the reviewed source, then wait for CI on that exact commit.
2. Commit the final changelog and reference metadata from preview to released.
   Require passing CI on that commit before creating the **0.3.0 Git tag** with
   release notes covering chart migration.
   Swift Package Manager resolves source from Git tags; there is no separate
   SwiftPM package upload for this repository.
3. Resolve that tag in a clean consumer. Update the installation examples from
   0.2.0 to 0.3.0 only once the tag exists and is verified.
4. Publish MCP 1.4.0, inspect the registry archive, and update its release notices.
5. Deploy the website after the documentation it links to is public. Verify
   screenshots, installation instructions, and the reference-file URL live.
6. Review GitHub About metadata:
   - Description: **Composable SwiftUI components, semantic themes, and
     interaction primitives for native Apple apps.**
   - Website: **https://shopofluba.de/lubaui**
   - Topics: **swift, swiftui, design-system, ios, components, accessibility, mcp**

Publishing, application upgrades, and website deployment are separate actions;
a passing local build does not perform any of them.
