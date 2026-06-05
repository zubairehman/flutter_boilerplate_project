# macOS Build Setup

After the `fix(macos): add keychain-access-groups entitlement` change, the
macOS build requires a development signing certificate. This is Xcode's
default behavior whenever an app declares an entitlement that touches the
keychain, even for local-only development builds.

## One-time setup

1. Open `macos/Runner.xcworkspace` in Xcode.
2. Select the **Runner** target in the left sidebar.
3. Open the **Signing & Capabilities** tab.
4. Enable **Automatically manage signing** and pick a Team (your personal
   Apple ID is fine for local development).
5. Close Xcode and re-run `flutter run -d macos`.

The signing config is per-developer and lives in
`macos/Runner.xcodeproj/project.pbxproj` — it's gitignored
(`xcuserdata/`, `*.xcuserstate`), so this step does not need to be
re-done by anyone else who clones the repo. They will see the same
"select a Team" prompt on first open.

## `keychain-access-groups` must use `$(AppIdentifierPrefix)`

The `keychain-access-groups` array entry in `macos/Runner/*.entitlements`
must start with `$(AppIdentifierPrefix)`, not the bare bundle ID:

```xml
<key>keychain-access-groups</key>
<array>
    <string>$(AppIdentifierPrefix)net.pyxlr.flutterBoilerplateProject</string>
</array>
```

Xcode expands `$(AppIdentifierPrefix)` to `<TeamID>.<bundleID>` at build
time. The provisioning profile also uses the `<TeamID>.<bundleID>` format
internally, so the two match. A literal bundle ID without the prefix
causes Xcode to fail with:

> Provisioning profile "Mac Team Provisioning Profile: <bundleID>"
> doesn't match the entitlements file's value for the
> keychain-access-groups entitlement.
