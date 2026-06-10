#!/usr/bin/env python3
"""
Generate an Xcode 13-compatible project.pbxproj for desktopAhaan.

Xcode 16+ uses objectVersion 77 and PBXFileSystemSynchronizedRootGroup,
which older Xcode cannot open. This script generates a traditional
project file with explicit PBXFileReference + PBXBuildFile entries
for every source and resource file, using objectVersion 56.
"""

import os
import hashlib
import sys

# ── Configuration ──────────────────────────────────────────────────

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SOURCE_DIR = os.path.join(PROJECT_ROOT, "desktopAhaan")
TEST_DIR = os.path.join(PROJECT_ROOT, "desktopAhaanTests")
UITEST_DIR = os.path.join(PROJECT_ROOT, "desktopAhaanUITests")
OUTPUT = os.path.join(PROJECT_ROOT, "desktopAhaan.xcodeproj", "project.pbxproj")

# Existing UUIDs from the original project (preserve for stability)
APP_TARGET_ID       = "0434CE862FA733CD000C01F2"
TEST_TARGET_ID      = "043BC1022FA79A3E006D6000"
PROJECT_ID          = "0434CE7F2FA733CD000C01F2"
MAIN_GROUP_ID       = "0434CE7E2FA733CD000C01F2"
PRODUCTS_GROUP_ID   = "0434CE882FA733CD000C01F2"
APP_PRODUCT_REF     = "0434CE872FA733CD000C01F2"
TEST_PRODUCT_REF    = "043BC1032FA79A3E006D6000"
PROXY_ID            = "043BC1072FA79A3E006D6000"
DEPENDENCY_ID       = "043BC1082FA79A3E006D6000"

# UITests target — these UUIDs were hand-assigned in the original
# project AND are baked into `desktopAhaan.xcscheme`'s TestAction
# (BlueprintIdentifier = "0AAA000000000000000000A7"). Don't change
# them or `xcodebuild test` will silently drop the UI test bundle.
# Restored 2026-05-23 — the generator was previously emitting the
# pbxproj without this target, which caused both crash repro tests
# to stop running on dev Macs (the scheme's TestableReference
# pointed at a non-existent BlueprintIdentifier and xcodebuild
# skipped it without complaint).
UITEST_TARGET_ID       = "0AAA000000000000000000A7"
UITEST_PRODUCT_REF     = "0AAA000000000000000000A3"
UITEST_PROXY_ID        = "0AAA000000000000000000A2"
UITEST_DEPENDENCY_ID   = "0AAA000000000000000000AA"
UITEST_SOURCES_PHASE   = "0AAA000000000000000000A9"
UITEST_FRAMEWORKS_PHASE= "0AAA000000000000000000A5"
UITEST_RESOURCES_PHASE = "0AAA000000000000000000A8"
UITEST_BCL             = "0AAA000000000000000000AD"
UITEST_DEBUG_ID        = "0AAA000000000000000000AB"
UITEST_RELEASE_ID      = "0AAA000000000000000000AC"
UITEST_SOURCE_GROUP_ID = "0AAA000000000000000000A6"

# Build configuration list IDs
PROJECT_BCL         = "0434CE822FA733CD000C01F2"
APP_BCL             = "0434CE942FA733CD000C01F2"
TEST_BCL            = "043BC1092FA79A3E006D6000"

# Build configuration IDs
PROJ_DEBUG_ID       = "0434CE922FA733CD000C01F2"
PROJ_RELEASE_ID     = "0434CE932FA733CD000C01F2"
APP_DEBUG_ID        = "0434CE952FA733CD000C01F2"
APP_RELEASE_ID      = "0434CE962FA733CD000C01F2"
TEST_DEBUG_ID       = "043BC10A2FA79A3E006D6000"
TEST_RELEASE_ID     = "043BC10B2FA79A3E006D6000"

# Build phase IDs
APP_SOURCES_PHASE   = "0434CE832FA733CD000C01F2"
APP_FRAMEWORKS_PHASE= "0434CE842FA733CD000C01F2"
APP_RESOURCES_PHASE = "0434CE852FA733CD000C01F2"
TEST_SOURCES_PHASE  = "043BC0FF2FA79A3E006D6000"
TEST_FRAMEWORKS_PHASE="043BC1002FA79A3E006D6000"
TEST_RESOURCES_PHASE= "043BC1012FA79A3E006D6000"

DEV_TEAM = "TQM5Y6FG3Z"

# ── Helpers ────────────────────────────────────────────────────────

def make_id(seed):
    """Generate a deterministic 24-char hex ID from a seed string."""
    return hashlib.md5(seed.encode()).hexdigest()[:24].upper()

def file_type(path):
    ext = os.path.splitext(path)[1].lower()
    return {
        ".swift": "sourcecode.swift",
        ".html": "text.html",
        ".css": "text.css",
        ".json": "text.json",
        ".entitlements": "com.apple.xcode.xml.entitlements-property-list",
        ".py": "text.script.python",
        ".md": "net.daringfireball.markdown",
        ".pdf": "image.pdf",
        ".xcassets": "folder.assetcatalog",
    }.get(ext, "text")

def is_source(path):
    return path.endswith(".swift")

def is_resource(path):
    # NOTE: .md and .pdf MUST be bundled — OlympiadPaperParser loads the
    # *_QuestionPaper.md / *_Solutions.md from Bundle.main and the print
    # surface opens the per-chapter .pdf. Omitting them (the bug fixed
    # 2026-06-10) silently strips ~211 TestPapers resources from the app
    # bundle: the build still succeeds, but every Olympiad paper fails to
    # load at runtime on the iMac. Keep .md/.pdf here.
    ext = os.path.splitext(path)[1].lower()
    return ext in (".html", ".css", ".json", ".md", ".pdf")

def is_asset_catalog(path):
    return path.endswith(".xcassets")

# ── Collect files ──────────────────────────────────────────────────

class FileEntry:
    def __init__(self, rel_path, abs_path):
        self.rel_path = rel_path  # relative to project root
        self.abs_path = abs_path
        self.name = os.path.basename(rel_path)
        self.file_ref_id = make_id("fileref:" + rel_path)
        self.build_file_id = make_id("buildfile:" + rel_path)
        self.ftype = file_type(rel_path)

class GroupEntry:
    def __init__(self, rel_path, name):
        self.rel_path = rel_path
        self.name = name
        self.group_id = make_id("group:" + rel_path)
        self.children_ids = []  # file ref IDs and sub-group IDs

def collect_app_files():
    """Collect all files under desktopAhaan/ (app target)."""
    files = []
    for root, dirs, filenames in os.walk(SOURCE_DIR):
        # Skip .xcassets internals (treat xcassets as a single folder ref)
        if ".xcassets" in root and root != SOURCE_DIR:
            # We're inside Assets.xcassets - skip individual files
            rel_check = os.path.relpath(root, SOURCE_DIR)
            if "Assets.xcassets" in rel_check and rel_check != "Assets.xcassets":
                continue

        # Skip scripts directory (not compiled)
        rel_dir = os.path.relpath(root, SOURCE_DIR)
        if rel_dir.startswith("scripts"):
            continue

        for fname in sorted(filenames):
            abs_path = os.path.join(root, fname)
            rel_path = os.path.relpath(abs_path, PROJECT_ROOT)

            # Skip DS_Store etc
            if fname.startswith("."):
                continue

            # Only include source and resource files
            if is_source(rel_path) or is_resource(rel_path):
                files.append(FileEntry(rel_path, abs_path))
            elif rel_path.endswith(".entitlements"):
                files.append(FileEntry(rel_path, abs_path))

    return files

def collect_test_files():
    files = []
    for root, dirs, filenames in os.walk(TEST_DIR):
        for fname in sorted(filenames):
            if fname.startswith("."):
                continue
            abs_path = os.path.join(root, fname)
            rel_path = os.path.relpath(abs_path, PROJECT_ROOT)
            if is_source(rel_path):
                files.append(FileEntry(rel_path, abs_path))
    return files

def collect_uitest_files():
    files = []
    if not os.path.isdir(UITEST_DIR):
        return files
    for root, dirs, filenames in os.walk(UITEST_DIR):
        for fname in sorted(filenames):
            if fname.startswith("."):
                continue
            abs_path = os.path.join(root, fname)
            rel_path = os.path.relpath(abs_path, PROJECT_ROOT)
            if is_source(rel_path):
                files.append(FileEntry(rel_path, abs_path))
    return files

def build_groups(files, base_dir, root_group_id):
    """Build PBXGroup tree from file list."""
    groups = {}  # rel_dir -> GroupEntry

    # Root group
    root_rel = os.path.relpath(base_dir, PROJECT_ROOT)
    root_group = GroupEntry(root_rel, os.path.basename(base_dir))
    root_group.group_id = root_group_id
    groups[root_rel] = root_group

    for f in files:
        # Get directory relative to project root
        file_dir = os.path.dirname(f.rel_path)

        # Ensure all parent groups exist
        parts = os.path.relpath(file_dir, root_rel).split(os.sep)
        if parts == ["."]:
            parts = []

        current_path = root_rel
        for part in parts:
            parent_path = current_path
            current_path = os.path.join(current_path, part)
            if current_path not in groups:
                g = GroupEntry(current_path, part)
                groups[current_path] = g
                # Add to parent
                groups[parent_path].children_ids.append(g.group_id)

        # Add file to its group
        groups[file_dir].children_ids.append(f.file_ref_id)

    return groups

# ── Generate pbxproj ──────────────────────────────────────────────

def generate():
    app_files = collect_app_files()
    test_files = collect_test_files()
    uitest_files = collect_uitest_files()

    # Asset catalog entry (treated as a single folder reference)
    xcassets_rel = "desktopAhaan/Assets.xcassets"
    xcassets_ref_id = make_id("fileref:" + xcassets_rel)
    xcassets_build_id = make_id("buildfile:" + xcassets_rel)

    # Groups
    APP_SOURCE_GROUP_ID = make_id("group:desktopAhaan")
    TEST_SOURCE_GROUP_ID = make_id("group:desktopAhaanTests")
    # UITests group uses the original hand-assigned ID so the scheme's
    # group-relative references (if any) resolve. Build groups uses
    # this id for the root.
    UITEST_SOURCE_GROUP_ID_LOCAL = UITEST_SOURCE_GROUP_ID

    app_groups = build_groups(app_files, SOURCE_DIR, APP_SOURCE_GROUP_ID)
    test_groups = build_groups(test_files, TEST_DIR, TEST_SOURCE_GROUP_ID)
    uitest_groups = build_groups(uitest_files, UITEST_DIR, UITEST_SOURCE_GROUP_ID_LOCAL) if uitest_files else {}

    # Add xcassets to the app root group
    app_root_group = app_groups["desktopAhaan"]
    app_root_group.children_ids.append(xcassets_ref_id)

    # Categorize app files
    app_sources = [f for f in app_files if is_source(f.rel_path)]
    app_resources = [f for f in app_files if is_resource(f.rel_path)]
    app_entitlements = [f for f in app_files if f.rel_path.endswith(".entitlements")]
    test_sources = test_files
    uitest_sources = uitest_files

    lines = []
    def w(s=""):
        lines.append(s)

    w("// !$*UTF8*$!")
    w("{")
    w("\tarchiveVersion = 1;")
    w("\tclasses = {")
    w("\t};")
    w("\tobjectVersion = 55;")
    w("\tobjects = {")
    w("")

    # ── PBXBuildFile ──
    w("/* Begin PBXBuildFile section */")
    for f in app_sources:
        w(f'\t\t{f.build_file_id} /* {f.name} in Sources */ = {{isa = PBXBuildFile; fileRef = {f.file_ref_id} /* {f.name} */; }};')
    for f in app_resources:
        w(f'\t\t{f.build_file_id} /* {f.name} in Resources */ = {{isa = PBXBuildFile; fileRef = {f.file_ref_id} /* {f.name} */; }};')
    # xcassets
    w(f'\t\t{xcassets_build_id} /* Assets.xcassets in Resources */ = {{isa = PBXBuildFile; fileRef = {xcassets_ref_id} /* Assets.xcassets */; }};')
    for f in test_sources:
        w(f'\t\t{f.build_file_id} /* {f.name} in Sources */ = {{isa = PBXBuildFile; fileRef = {f.file_ref_id} /* {f.name} */; }};')
    for f in uitest_sources:
        w(f'\t\t{f.build_file_id} /* {f.name} in Sources */ = {{isa = PBXBuildFile; fileRef = {f.file_ref_id} /* {f.name} */; }};')
    w("/* End PBXBuildFile section */")
    w("")

    # ── PBXContainerItemProxy ──
    w("/* Begin PBXContainerItemProxy section */")
    w(f"\t\t{PROXY_ID} /* PBXContainerItemProxy */ = {{")
    w(f"\t\t\tisa = PBXContainerItemProxy;")
    w(f"\t\t\tcontainerPortal = {PROJECT_ID} /* Project object */;")
    w(f"\t\t\tproxyType = 1;")
    w(f"\t\t\tremoteGlobalIDString = {APP_TARGET_ID};")
    w(f"\t\t\tremoteInfo = desktopAhaan;")
    w(f"\t\t}};")
    # UI test target depends on the app target — emit a second proxy
    # so each test target has its own dependency wiring. Without this
    # the UITests target compiles but xcodebuild can't infer the host
    # app at test time.
    if uitest_sources:
        w(f"\t\t{UITEST_PROXY_ID} /* PBXContainerItemProxy */ = {{")
        w(f"\t\t\tisa = PBXContainerItemProxy;")
        w(f"\t\t\tcontainerPortal = {PROJECT_ID} /* Project object */;")
        w(f"\t\t\tproxyType = 1;")
        w(f"\t\t\tremoteGlobalIDString = {APP_TARGET_ID};")
        w(f"\t\t\tremoteInfo = desktopAhaan;")
        w(f"\t\t}};")
    w("/* End PBXContainerItemProxy section */")
    w("")

    # ── PBXFileReference ──
    w("/* Begin PBXFileReference section */")
    # Products
    w(f'\t\t{APP_PRODUCT_REF} /* desktopAhaan.app */ = {{isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = desktopAhaan.app; sourceTree = BUILT_PRODUCTS_DIR; }};')
    w(f'\t\t{TEST_PRODUCT_REF} /* desktopAhaanTests.xctest */ = {{isa = PBXFileReference; explicitFileType = wrapper.cfbundle; includeInIndex = 0; path = desktopAhaanTests.xctest; sourceTree = BUILT_PRODUCTS_DIR; }};')
    # App files
    for f in app_files:
        w(f'\t\t{f.file_ref_id} /* {f.name} */ = {{isa = PBXFileReference; lastKnownFileType = {f.ftype}; path = "{f.name}"; sourceTree = "<group>"; }};')
    # xcassets
    w(f'\t\t{xcassets_ref_id} /* Assets.xcassets */ = {{isa = PBXFileReference; lastKnownFileType = folder.assetcatalog; path = Assets.xcassets; sourceTree = "<group>"; }};')
    # Test files
    for f in test_files:
        w(f'\t\t{f.file_ref_id} /* {f.name} */ = {{isa = PBXFileReference; lastKnownFileType = {f.ftype}; path = "{f.name}"; sourceTree = "<group>"; }};')
    # UITest product + sources
    if uitest_sources:
        w(f'\t\t{UITEST_PRODUCT_REF} /* desktopAhaanUITests.xctest */ = {{isa = PBXFileReference; explicitFileType = wrapper.cfbundle; includeInIndex = 0; path = desktopAhaanUITests.xctest; sourceTree = BUILT_PRODUCTS_DIR; }};')
        for f in uitest_files:
            w(f'\t\t{f.file_ref_id} /* {f.name} */ = {{isa = PBXFileReference; lastKnownFileType = {f.ftype}; path = "{f.name}"; sourceTree = "<group>"; }};')
    w("/* End PBXFileReference section */")
    w("")

    # ── PBXFrameworksBuildPhase ──
    w("/* Begin PBXFrameworksBuildPhase section */")
    w(f"\t\t{APP_FRAMEWORKS_PHASE} /* Frameworks */ = {{")
    w(f"\t\t\tisa = PBXFrameworksBuildPhase;")
    w(f"\t\t\tbuildActionMask = 2147483647;")
    w(f"\t\t\tfiles = (")
    w(f"\t\t\t);")
    w(f"\t\t\trunOnlyForDeploymentPostprocessing = 0;")
    w(f"\t\t}};")
    w(f"\t\t{TEST_FRAMEWORKS_PHASE} /* Frameworks */ = {{")
    w(f"\t\t\tisa = PBXFrameworksBuildPhase;")
    w(f"\t\t\tbuildActionMask = 2147483647;")
    w(f"\t\t\tfiles = (")
    w(f"\t\t\t);")
    w(f"\t\t\trunOnlyForDeploymentPostprocessing = 0;")
    w(f"\t\t}};")
    if uitest_sources:
        w(f"\t\t{UITEST_FRAMEWORKS_PHASE} /* Frameworks */ = {{")
        w(f"\t\t\tisa = PBXFrameworksBuildPhase;")
        w(f"\t\t\tbuildActionMask = 2147483647;")
        w(f"\t\t\tfiles = (")
        w(f"\t\t\t);")
        w(f"\t\t\trunOnlyForDeploymentPostprocessing = 0;")
        w(f"\t\t}};")
    w("/* End PBXFrameworksBuildPhase section */")
    w("")

    # ── PBXGroup ──
    w("/* Begin PBXGroup section */")

    # Main group (root of project)
    w(f"\t\t{MAIN_GROUP_ID} = {{")
    w(f"\t\t\tisa = PBXGroup;")
    w(f"\t\t\tchildren = (")
    w(f"\t\t\t\t{APP_SOURCE_GROUP_ID} /* desktopAhaan */,")
    w(f"\t\t\t\t{TEST_SOURCE_GROUP_ID} /* desktopAhaanTests */,")
    if uitest_sources:
        w(f"\t\t\t\t{UITEST_SOURCE_GROUP_ID} /* desktopAhaanUITests */,")
    w(f"\t\t\t\t{PRODUCTS_GROUP_ID} /* Products */,")
    w(f"\t\t\t);")
    w(f'\t\t\tsourceTree = "<group>";')
    w(f"\t\t}};")

    # Products group
    w(f"\t\t{PRODUCTS_GROUP_ID} /* Products */ = {{")
    w(f"\t\t\tisa = PBXGroup;")
    w(f"\t\t\tchildren = (")
    w(f"\t\t\t\t{APP_PRODUCT_REF} /* desktopAhaan.app */,")
    w(f"\t\t\t\t{TEST_PRODUCT_REF} /* desktopAhaanTests.xctest */,")
    if uitest_sources:
        w(f"\t\t\t\t{UITEST_PRODUCT_REF} /* desktopAhaanUITests.xctest */,")
    w(f"\t\t\t);")
    w(f"\t\t\tname = Products;")
    w(f'\t\t\tsourceTree = "<group>";')
    w(f"\t\t}};")

    # App groups
    for rel_path, g in sorted(app_groups.items()):
        w(f"\t\t{g.group_id} /* {g.name} */ = {{")
        w(f"\t\t\tisa = PBXGroup;")
        w(f"\t\t\tchildren = (")
        for child_id in g.children_ids:
            w(f"\t\t\t\t{child_id},")
        w(f"\t\t\t);")
        if g.group_id != APP_SOURCE_GROUP_ID:
            w(f'\t\t\tpath = "{g.name}";')
        else:
            w(f'\t\t\tpath = desktopAhaan;')
        w(f'\t\t\tsourceTree = "<group>";')
        w(f"\t\t}};")

    # Test groups
    for rel_path, g in sorted(test_groups.items()):
        w(f"\t\t{g.group_id} /* {g.name} */ = {{")
        w(f"\t\t\tisa = PBXGroup;")
        w(f"\t\t\tchildren = (")
        for child_id in g.children_ids:
            w(f"\t\t\t\t{child_id},")
        w(f"\t\t\t);")
        if g.group_id != TEST_SOURCE_GROUP_ID:
            w(f'\t\t\tpath = "{g.name}";')
        else:
            w(f'\t\t\tpath = desktopAhaanTests;')
        w(f'\t\t\tsourceTree = "<group>";')
        w(f"\t\t}};")

    # UITest groups (same shape as Test groups; only emitted if there
    # are UITests on disk so projects that haven't built a UI test
    # bundle yet stay unchanged).
    if uitest_groups:
        for rel_path, g in sorted(uitest_groups.items()):
            w(f"\t\t{g.group_id} /* {g.name} */ = {{")
            w(f"\t\t\tisa = PBXGroup;")
            w(f"\t\t\tchildren = (")
            for child_id in g.children_ids:
                w(f"\t\t\t\t{child_id},")
            w(f"\t\t\t);")
            if g.group_id != UITEST_SOURCE_GROUP_ID:
                w(f'\t\t\tpath = "{g.name}";')
            else:
                w(f'\t\t\tpath = desktopAhaanUITests;')
            w(f'\t\t\tsourceTree = "<group>";')
            w(f"\t\t}};")

    w("/* End PBXGroup section */")
    w("")

    # ── PBXNativeTarget ──
    w("/* Begin PBXNativeTarget section */")
    # App target
    w(f"\t\t{APP_TARGET_ID} /* desktopAhaan */ = {{")
    w(f"\t\t\tisa = PBXNativeTarget;")
    w(f"\t\t\tbuildConfigurationList = {APP_BCL} /* Build configuration list for PBXNativeTarget \"desktopAhaan\" */;")
    w(f"\t\t\tbuildPhases = (")
    w(f"\t\t\t\t{APP_SOURCES_PHASE} /* Sources */,")
    w(f"\t\t\t\t{APP_FRAMEWORKS_PHASE} /* Frameworks */,")
    w(f"\t\t\t\t{APP_RESOURCES_PHASE} /* Resources */,")
    w(f"\t\t\t);")
    w(f"\t\t\tbuildRules = (")
    w(f"\t\t\t);")
    w(f"\t\t\tdependencies = (")
    w(f"\t\t\t);")
    w(f"\t\t\tname = desktopAhaan;")
    w(f"\t\t\tpackageProductDependencies = (")
    w(f"\t\t\t);")
    w(f"\t\t\tproductName = desktopAhaan;")
    w(f"\t\t\tproductReference = {APP_PRODUCT_REF} /* desktopAhaan.app */;")
    w(f'\t\t\tproductType = "com.apple.product-type.application";')
    w(f"\t\t}};")
    # Test target
    w(f"\t\t{TEST_TARGET_ID} /* desktopAhaanTests */ = {{")
    w(f"\t\t\tisa = PBXNativeTarget;")
    w(f"\t\t\tbuildConfigurationList = {TEST_BCL} /* Build configuration list for PBXNativeTarget \"desktopAhaanTests\" */;")
    w(f"\t\t\tbuildPhases = (")
    w(f"\t\t\t\t{TEST_SOURCES_PHASE} /* Sources */,")
    w(f"\t\t\t\t{TEST_FRAMEWORKS_PHASE} /* Frameworks */,")
    w(f"\t\t\t\t{TEST_RESOURCES_PHASE} /* Resources */,")
    w(f"\t\t\t);")
    w(f"\t\t\tbuildRules = (")
    w(f"\t\t\t);")
    w(f"\t\t\tdependencies = (")
    w(f"\t\t\t\t{DEPENDENCY_ID} /* PBXTargetDependency */,")
    w(f"\t\t\t);")
    w(f"\t\t\tname = desktopAhaanTests;")
    w(f"\t\t\tpackageProductDependencies = (")
    w(f"\t\t\t);")
    w(f"\t\t\tproductName = desktopAhaanTests;")
    w(f"\t\t\tproductReference = {TEST_PRODUCT_REF} /* desktopAhaanTests.xctest */;")
    w(f'\t\t\tproductType = "com.apple.product-type.bundle.unit-test";')
    w(f"\t\t}};")
    # UITest target — distinct product type
    # `com.apple.product-type.bundle.ui-testing`; xcodebuild routes
    # it to the XCTestPlanService that drives Accessibility events.
    if uitest_sources:
        w(f"\t\t{UITEST_TARGET_ID} /* desktopAhaanUITests */ = {{")
        w(f"\t\t\tisa = PBXNativeTarget;")
        w(f"\t\t\tbuildConfigurationList = {UITEST_BCL} /* Build configuration list for PBXNativeTarget \"desktopAhaanUITests\" */;")
        w(f"\t\t\tbuildPhases = (")
        w(f"\t\t\t\t{UITEST_SOURCES_PHASE} /* Sources */,")
        w(f"\t\t\t\t{UITEST_FRAMEWORKS_PHASE} /* Frameworks */,")
        w(f"\t\t\t\t{UITEST_RESOURCES_PHASE} /* Resources */,")
        w(f"\t\t\t);")
        w(f"\t\t\tbuildRules = (")
        w(f"\t\t\t);")
        w(f"\t\t\tdependencies = (")
        w(f"\t\t\t\t{UITEST_DEPENDENCY_ID} /* PBXTargetDependency */,")
        w(f"\t\t\t);")
        w(f"\t\t\tname = desktopAhaanUITests;")
        w(f"\t\t\tpackageProductDependencies = (")
        w(f"\t\t\t);")
        w(f"\t\t\tproductName = desktopAhaanUITests;")
        w(f"\t\t\tproductReference = {UITEST_PRODUCT_REF} /* desktopAhaanUITests.xctest */;")
        w(f'\t\t\tproductType = "com.apple.product-type.bundle.ui-testing";')
        w(f"\t\t}};")
    w("/* End PBXNativeTarget section */")
    w("")

    # ── PBXProject ──
    w("/* Begin PBXProject section */")
    w(f"\t\t{PROJECT_ID} /* Project object */ = {{")
    w(f"\t\t\tisa = PBXProject;")
    w(f"\t\t\tattributes = {{")
    w(f"\t\t\t\tBuildIndependentTargetsInParallel = 1;")
    w(f"\t\t\t\tLastSwiftUpdateCheck = 1320;")
    w(f"\t\t\t\tLastUpgradeCheck = 1320;")
    w(f"\t\t\t\tTargetAttributes = {{")
    w(f"\t\t\t\t\t{APP_TARGET_ID} = {{")
    w(f"\t\t\t\t\t\tCreatedOnToolsVersion = 13.2;")
    w(f"\t\t\t\t\t}};")
    w(f"\t\t\t\t\t{TEST_TARGET_ID} = {{")
    w(f"\t\t\t\t\t\tCreatedOnToolsVersion = 13.2;")
    w(f"\t\t\t\t\t\tTestTargetID = {APP_TARGET_ID};")
    w(f"\t\t\t\t\t}};")
    if uitest_sources:
        w(f"\t\t\t\t\t{UITEST_TARGET_ID} = {{")
        w(f"\t\t\t\t\t\tCreatedOnToolsVersion = 13.2;")
        w(f"\t\t\t\t\t\tTestTargetID = {APP_TARGET_ID};")
        w(f"\t\t\t\t\t}};")
    w(f"\t\t\t\t}};")
    w(f"\t\t\t}};")
    w(f"\t\t\tbuildConfigurationList = {PROJECT_BCL} /* Build configuration list for PBXProject \"desktopAhaan\" */;")
    w(f"\t\t\tcompatibilityVersion = \"Xcode 13.0\";")
    w(f"\t\t\tdevelopmentRegion = en;")
    w(f"\t\t\thasScannedForEncodings = 0;")
    w(f"\t\t\tknownRegions = (")
    w(f"\t\t\t\ten,")
    w(f"\t\t\t\tBase,")
    w(f"\t\t\t);")
    w(f"\t\t\tmainGroup = {MAIN_GROUP_ID};")
    w(f"\t\t\tproductRefGroup = {PRODUCTS_GROUP_ID} /* Products */;")
    w(f'\t\t\tprojectDirPath = "";')
    w(f'\t\t\tprojectRoot = "";')
    w(f"\t\t\ttargets = (")
    w(f"\t\t\t\t{APP_TARGET_ID} /* desktopAhaan */,")
    w(f"\t\t\t\t{TEST_TARGET_ID} /* desktopAhaanTests */,")
    if uitest_sources:
        w(f"\t\t\t\t{UITEST_TARGET_ID} /* desktopAhaanUITests */,")
    w(f"\t\t\t);")
    w(f"\t\t}};")
    w("/* End PBXProject section */")
    w("")

    # ── PBXResourcesBuildPhase ──
    w("/* Begin PBXResourcesBuildPhase section */")
    w(f"\t\t{APP_RESOURCES_PHASE} /* Resources */ = {{")
    w(f"\t\t\tisa = PBXResourcesBuildPhase;")
    w(f"\t\t\tbuildActionMask = 2147483647;")
    w(f"\t\t\tfiles = (")
    for f in app_resources:
        w(f"\t\t\t\t{f.build_file_id} /* {f.name} in Resources */,")
    w(f"\t\t\t\t{xcassets_build_id} /* Assets.xcassets in Resources */,")
    w(f"\t\t\t);")
    w(f"\t\t\trunOnlyForDeploymentPostprocessing = 0;")
    w(f"\t\t}};")
    w(f"\t\t{TEST_RESOURCES_PHASE} /* Resources */ = {{")
    w(f"\t\t\tisa = PBXResourcesBuildPhase;")
    w(f"\t\t\tbuildActionMask = 2147483647;")
    w(f"\t\t\tfiles = (")
    w(f"\t\t\t);")
    w(f"\t\t\trunOnlyForDeploymentPostprocessing = 0;")
    w(f"\t\t}};")
    if uitest_sources:
        w(f"\t\t{UITEST_RESOURCES_PHASE} /* Resources */ = {{")
        w(f"\t\t\tisa = PBXResourcesBuildPhase;")
        w(f"\t\t\tbuildActionMask = 2147483647;")
        w(f"\t\t\tfiles = (")
        w(f"\t\t\t);")
        w(f"\t\t\trunOnlyForDeploymentPostprocessing = 0;")
        w(f"\t\t}};")
    w("/* End PBXResourcesBuildPhase section */")
    w("")

    # ── PBXSourcesBuildPhase ──
    w("/* Begin PBXSourcesBuildPhase section */")
    w(f"\t\t{APP_SOURCES_PHASE} /* Sources */ = {{")
    w(f"\t\t\tisa = PBXSourcesBuildPhase;")
    w(f"\t\t\tbuildActionMask = 2147483647;")
    w(f"\t\t\tfiles = (")
    for f in app_sources:
        w(f"\t\t\t\t{f.build_file_id} /* {f.name} in Sources */,")
    w(f"\t\t\t);")
    w(f"\t\t\trunOnlyForDeploymentPostprocessing = 0;")
    w(f"\t\t}};")
    w(f"\t\t{TEST_SOURCES_PHASE} /* Sources */ = {{")
    w(f"\t\t\tisa = PBXSourcesBuildPhase;")
    w(f"\t\t\tbuildActionMask = 2147483647;")
    w(f"\t\t\tfiles = (")
    for f in test_sources:
        w(f"\t\t\t\t{f.build_file_id} /* {f.name} in Sources */,")
    w(f"\t\t\t);")
    w(f"\t\t\trunOnlyForDeploymentPostprocessing = 0;")
    w(f"\t\t}};")
    if uitest_sources:
        w(f"\t\t{UITEST_SOURCES_PHASE} /* Sources */ = {{")
        w(f"\t\t\tisa = PBXSourcesBuildPhase;")
        w(f"\t\t\tbuildActionMask = 2147483647;")
        w(f"\t\t\tfiles = (")
        for f in uitest_sources:
            w(f"\t\t\t\t{f.build_file_id} /* {f.name} in Sources */,")
        w(f"\t\t\t);")
        w(f"\t\t\trunOnlyForDeploymentPostprocessing = 0;")
        w(f"\t\t}};")
    w("/* End PBXSourcesBuildPhase section */")
    w("")

    # ── PBXTargetDependency ──
    w("/* Begin PBXTargetDependency section */")
    w(f"\t\t{DEPENDENCY_ID} /* PBXTargetDependency */ = {{")
    w(f"\t\t\tisa = PBXTargetDependency;")
    w(f"\t\t\ttarget = {APP_TARGET_ID} /* desktopAhaan */;")
    w(f"\t\t\ttargetProxy = {PROXY_ID} /* PBXContainerItemProxy */;")
    w(f"\t\t}};")
    if uitest_sources:
        w(f"\t\t{UITEST_DEPENDENCY_ID} /* PBXTargetDependency */ = {{")
        w(f"\t\t\tisa = PBXTargetDependency;")
        w(f"\t\t\ttarget = {APP_TARGET_ID} /* desktopAhaan */;")
        w(f"\t\t\ttargetProxy = {UITEST_PROXY_ID} /* PBXContainerItemProxy */;")
        w(f"\t\t}};")
    w("/* End PBXTargetDependency section */")
    w("")

    # ── XCBuildConfiguration ──
    w("/* Begin XCBuildConfiguration section */")

    # Project-level Debug
    w(f"\t\t{PROJ_DEBUG_ID} /* Debug */ = {{")
    w(f"\t\t\tisa = XCBuildConfiguration;")
    w(f"\t\t\tbuildSettings = {{")
    w(f"\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO;")
    w(f"\t\t\t\tCLANG_ANALYZER_NONNULL = YES;")
    w(f"\t\t\t\tCLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;")
    w(f'\t\t\t\tCLANG_CXX_LANGUAGE_STANDARD = "gnu++20";')
    w(f"\t\t\t\tCLANG_ENABLE_MODULES = YES;")
    w(f"\t\t\t\tCLANG_ENABLE_OBJC_ARC = YES;")
    w(f"\t\t\t\tCLANG_ENABLE_OBJC_WEAK = YES;")
    w(f"\t\t\t\tCLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;")
    w(f"\t\t\t\tCLANG_WARN_BOOL_CONVERSION = YES;")
    w(f"\t\t\t\tCLANG_WARN_COMMA = YES;")
    w(f"\t\t\t\tCLANG_WARN_CONSTANT_CONVERSION = YES;")
    w(f"\t\t\t\tCLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;")
    w(f"\t\t\t\tCLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;")
    w(f"\t\t\t\tCLANG_WARN_DOCUMENTATION_COMMENTS = YES;")
    w(f"\t\t\t\tCLANG_WARN_EMPTY_BODY = YES;")
    w(f"\t\t\t\tCLANG_WARN_ENUM_CONVERSION = YES;")
    w(f"\t\t\t\tCLANG_WARN_INFINITE_RECURSION = YES;")
    w(f"\t\t\t\tCLANG_WARN_INT_CONVERSION = YES;")
    w(f"\t\t\t\tCLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;")
    w(f"\t\t\t\tCLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;")
    w(f"\t\t\t\tCLANG_WARN_OBJC_LITERAL_CONVERSION = YES;")
    w(f"\t\t\t\tCLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;")
    w(f"\t\t\t\tCLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES;")
    w(f"\t\t\t\tCLANG_WARN_RANGE_LOOP_ANALYSIS = YES;")
    w(f"\t\t\t\tCLANG_WARN_STRICT_PROTOTYPES = YES;")
    w(f"\t\t\t\tCLANG_WARN_SUSPICIOUS_MOVE = YES;")
    w(f"\t\t\t\tCLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE;")
    w(f"\t\t\t\tCLANG_WARN_UNREACHABLE_CODE = YES;")
    w(f"\t\t\t\tCLANG_WARN__DUPLICATE_METHOD_MATCH = YES;")
    w(f"\t\t\t\tCOPY_PHASE_STRIP = NO;")
    w(f"\t\t\t\tDEBUG_INFORMATION_FORMAT = dwarf;")
    w(f"\t\t\t\tDEVELOPMENT_TEAM = {DEV_TEAM};")
    w(f"\t\t\t\tENABLE_STRICT_OBJC_MSGSEND = YES;")
    w(f"\t\t\t\tENABLE_TESTABILITY = YES;")
    w(f"\t\t\t\tGCC_C_LANGUAGE_STANDARD = gnu17;")
    w(f"\t\t\t\tGCC_DYNAMIC_NO_PIC = NO;")
    w(f"\t\t\t\tGCC_NO_COMMON_BLOCKS = YES;")
    w(f"\t\t\t\tGCC_OPTIMIZATION_LEVEL = 0;")
    w(f"\t\t\t\tGCC_PREPROCESSOR_DEFINITIONS = (")
    w(f'\t\t\t\t\t"DEBUG=1",')
    w(f'\t\t\t\t\t"$(inherited)",')
    w(f"\t\t\t\t);")
    w(f"\t\t\t\tGCC_WARN_64_TO_32_BIT_CONVERSION = YES;")
    w(f"\t\t\t\tGCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;")
    w(f"\t\t\t\tGCC_WARN_UNDECLARED_SELECTOR = YES;")
    w(f"\t\t\t\tGCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;")
    w(f"\t\t\t\tGCC_WARN_UNUSED_FUNCTION = YES;")
    w(f"\t\t\t\tGCC_WARN_UNUSED_VARIABLE = YES;")
    w(f"\t\t\t\tMACOSX_DEPLOYMENT_TARGET = 11.5;")
    w(f"\t\t\t\tMTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;")
    w(f"\t\t\t\tMTL_FAST_MATH = YES;")
    w(f"\t\t\t\tONLY_ACTIVE_ARCH = YES;")
    w(f"\t\t\t\tSDKROOT = macosx;")
    w(f'\t\t\t\tSWIFT_ACTIVE_COMPILATION_CONDITIONS = "DEBUG $(inherited)";')
    w(f'\t\t\t\tSWIFT_OPTIMIZATION_LEVEL = "-Onone";')
    w(f"\t\t\t}};")
    w(f"\t\t\tname = Debug;")
    w(f"\t\t}};")

    # Project-level Release
    w(f"\t\t{PROJ_RELEASE_ID} /* Release */ = {{")
    w(f"\t\t\tisa = XCBuildConfiguration;")
    w(f"\t\t\tbuildSettings = {{")
    w(f"\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO;")
    w(f"\t\t\t\tCLANG_ANALYZER_NONNULL = YES;")
    w(f"\t\t\t\tCLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;")
    w(f'\t\t\t\tCLANG_CXX_LANGUAGE_STANDARD = "gnu++20";')
    w(f"\t\t\t\tCLANG_ENABLE_MODULES = YES;")
    w(f"\t\t\t\tCLANG_ENABLE_OBJC_ARC = YES;")
    w(f"\t\t\t\tCLANG_ENABLE_OBJC_WEAK = YES;")
    w(f"\t\t\t\tCLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;")
    w(f"\t\t\t\tCLANG_WARN_BOOL_CONVERSION = YES;")
    w(f"\t\t\t\tCLANG_WARN_COMMA = YES;")
    w(f"\t\t\t\tCLANG_WARN_CONSTANT_CONVERSION = YES;")
    w(f"\t\t\t\tCLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;")
    w(f"\t\t\t\tCLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;")
    w(f"\t\t\t\tCLANG_WARN_DOCUMENTATION_COMMENTS = YES;")
    w(f"\t\t\t\tCLANG_WARN_EMPTY_BODY = YES;")
    w(f"\t\t\t\tCLANG_WARN_ENUM_CONVERSION = YES;")
    w(f"\t\t\t\tCLANG_WARN_INFINITE_RECURSION = YES;")
    w(f"\t\t\t\tCLANG_WARN_INT_CONVERSION = YES;")
    w(f"\t\t\t\tCLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;")
    w(f"\t\t\t\tCLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;")
    w(f"\t\t\t\tCLANG_WARN_OBJC_LITERAL_CONVERSION = YES;")
    w(f"\t\t\t\tCLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;")
    w(f"\t\t\t\tCLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES;")
    w(f"\t\t\t\tCLANG_WARN_RANGE_LOOP_ANALYSIS = YES;")
    w(f"\t\t\t\tCLANG_WARN_STRICT_PROTOTYPES = YES;")
    w(f"\t\t\t\tCLANG_WARN_SUSPICIOUS_MOVE = YES;")
    w(f"\t\t\t\tCLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE;")
    w(f"\t\t\t\tCLANG_WARN_UNREACHABLE_CODE = YES;")
    w(f"\t\t\t\tCLANG_WARN__DUPLICATE_METHOD_MATCH = YES;")
    w(f"\t\t\t\tCOPY_PHASE_STRIP = NO;")
    w(f'\t\t\t\tDEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";')
    w(f"\t\t\t\tDEVELOPMENT_TEAM = {DEV_TEAM};")
    w(f"\t\t\t\tENABLE_NS_ASSERTIONS = NO;")
    w(f"\t\t\t\tENABLE_STRICT_OBJC_MSGSEND = YES;")
    w(f"\t\t\t\tGCC_C_LANGUAGE_STANDARD = gnu17;")
    w(f"\t\t\t\tGCC_NO_COMMON_BLOCKS = YES;")
    w(f"\t\t\t\tGCC_WARN_64_TO_32_BIT_CONVERSION = YES;")
    w(f"\t\t\t\tGCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;")
    w(f"\t\t\t\tGCC_WARN_UNDECLARED_SELECTOR = YES;")
    w(f"\t\t\t\tGCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;")
    w(f"\t\t\t\tGCC_WARN_UNUSED_FUNCTION = YES;")
    w(f"\t\t\t\tGCC_WARN_UNUSED_VARIABLE = YES;")
    w(f"\t\t\t\tMACOSX_DEPLOYMENT_TARGET = 11.5;")
    w(f"\t\t\t\tMTL_ENABLE_DEBUG_INFO = NO;")
    w(f"\t\t\t\tMTL_FAST_MATH = YES;")
    w(f"\t\t\t\tONLY_ACTIVE_ARCH = NO;")
    w(f"\t\t\t\tSDKROOT = macosx;")
    w(f"\t\t\t\tSWIFT_COMPILATION_MODE = wholemodule;")
    w(f"\t\t\t}};")
    w(f"\t\t\tname = Release;")
    w(f"\t\t}};")

    # App target Debug
    w(f"\t\t{APP_DEBUG_ID} /* Debug */ = {{")
    w(f"\t\t\tisa = XCBuildConfiguration;")
    w(f"\t\t\tbuildSettings = {{")
    w(f"\t\t\t\tASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;")
    w(f"\t\t\t\tASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;")
    w(f'\t\t\t\t"CODE_SIGN_ENTITLEMENTS[sdk=macosx*]" = desktopAhaan/desktopAhaan.entitlements;')
    w(f'\t\t\t\t"CODE_SIGN_IDENTITY[sdk=macosx*]" = "Apple Development";')
    w(f"\t\t\t\tCODE_SIGN_STYLE = Automatic;")
    w(f"\t\t\t\tCOMBINE_HIDPI_IMAGES = YES;")
    w(f"\t\t\t\tCURRENT_PROJECT_VERSION = 1;")
    w(f"\t\t\t\tDEVELOPMENT_TEAM = {DEV_TEAM};")
    w(f"\t\t\t\tENABLE_APP_SANDBOX = YES;")
    w(f"\t\t\t\tENABLE_HARDENED_RUNTIME = YES;")
    w(f"\t\t\t\tENABLE_PREVIEWS = YES;")
    w(f"\t\t\t\tGENERATE_INFOPLIST_FILE = YES;")
    w(f'\t\t\t\tINFOPLIST_KEY_NSHumanReadableCopyright = "";')
    w(f'\t\t\t\tINFOPLIST_KEY_NSMicrophoneUsageDescription = "Microphone access is used for voice input translation.";')
    w(f'\t\t\t\tINFOPLIST_KEY_NSSpeechRecognitionUsageDescription = "Speech recognition converts your spoken words into text for translation.";')
    w(f"\t\t\t\tLD_RUNPATH_SEARCH_PATHS = (")
    w(f'\t\t\t\t\t"$(inherited)",')
    w(f'\t\t\t\t\t"@executable_path/../Frameworks",')
    w(f"\t\t\t\t);")
    w(f"\t\t\t\tMARKETING_VERSION = 1.0;")
    w(f"\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.emoha.desktopAhaan;")
    w(f'\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";')
    w(f"\t\t\t\tSWIFT_EMIT_LOC_STRINGS = YES;")
    w(f"\t\t\t\tSWIFT_VERSION = 5.0;")
    w(f"\t\t\t}};")
    w(f"\t\t\tname = Debug;")
    w(f"\t\t}};")

    # App target Release
    w(f"\t\t{APP_RELEASE_ID} /* Release */ = {{")
    w(f"\t\t\tisa = XCBuildConfiguration;")
    w(f"\t\t\tbuildSettings = {{")
    w(f"\t\t\t\tASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;")
    w(f"\t\t\t\tASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;")
    w(f'\t\t\t\t"CODE_SIGN_ENTITLEMENTS[sdk=macosx*]" = desktopAhaan/desktopAhaan.entitlements;')
    w(f'\t\t\t\t"CODE_SIGN_IDENTITY[sdk=macosx*]" = "Apple Development";')
    w(f"\t\t\t\tCODE_SIGN_STYLE = Automatic;")
    w(f"\t\t\t\tCOMBINE_HIDPI_IMAGES = YES;")
    w(f"\t\t\t\tCURRENT_PROJECT_VERSION = 1;")
    w(f"\t\t\t\tDEVELOPMENT_TEAM = {DEV_TEAM};")
    w(f"\t\t\t\tENABLE_APP_SANDBOX = YES;")
    w(f"\t\t\t\tENABLE_HARDENED_RUNTIME = YES;")
    w(f"\t\t\t\tENABLE_PREVIEWS = YES;")
    w(f"\t\t\t\tGENERATE_INFOPLIST_FILE = YES;")
    w(f'\t\t\t\tINFOPLIST_KEY_NSHumanReadableCopyright = "";')
    w(f'\t\t\t\tINFOPLIST_KEY_NSMicrophoneUsageDescription = "Microphone access is used for voice input translation.";')
    w(f'\t\t\t\tINFOPLIST_KEY_NSSpeechRecognitionUsageDescription = "Speech recognition converts your spoken words into text for translation.";')
    w(f"\t\t\t\tLD_RUNPATH_SEARCH_PATHS = (")
    w(f'\t\t\t\t\t"$(inherited)",')
    w(f'\t\t\t\t\t"@executable_path/../Frameworks",')
    w(f"\t\t\t\t);")
    w(f"\t\t\t\tMARKETING_VERSION = 1.0;")
    w(f"\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.emoha.desktopAhaan;")
    w(f'\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";')
    w(f"\t\t\t\tSWIFT_EMIT_LOC_STRINGS = YES;")
    w(f"\t\t\t\tSWIFT_VERSION = 5.0;")
    w(f"\t\t\t}};")
    w(f"\t\t\tname = Release;")
    w(f"\t\t}};")

    # Test target Debug
    w(f"\t\t{TEST_DEBUG_ID} /* Debug */ = {{")
    w(f"\t\t\tisa = XCBuildConfiguration;")
    w(f"\t\t\tbuildSettings = {{")
    w(f'\t\t\t\tBUNDLE_LOADER = "$(TEST_HOST)";')
    w(f"\t\t\t\tCODE_SIGN_STYLE = Automatic;")
    w(f"\t\t\t\tCURRENT_PROJECT_VERSION = 1;")
    w(f"\t\t\t\tDEVELOPMENT_TEAM = {DEV_TEAM};")
    w(f"\t\t\t\tGENERATE_INFOPLIST_FILE = YES;")
    w(f"\t\t\t\tMARKETING_VERSION = 1.0;")
    w(f"\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.emoha.desktopAhaanTests;")
    w(f'\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";')
    w(f"\t\t\t\tSWIFT_EMIT_LOC_STRINGS = NO;")
    w(f"\t\t\t\tSWIFT_VERSION = 5.0;")
    w(f'\t\t\t\tTEST_HOST = "$(BUILT_PRODUCTS_DIR)/desktopAhaan.app/$(BUNDLE_EXECUTABLE_FOLDER_PATH)/desktopAhaan";')
    w(f"\t\t\t}};")
    w(f"\t\t\tname = Debug;")
    w(f"\t\t}};")

    # Test target Release
    w(f"\t\t{TEST_RELEASE_ID} /* Release */ = {{")
    w(f"\t\t\tisa = XCBuildConfiguration;")
    w(f"\t\t\tbuildSettings = {{")
    w(f'\t\t\t\tBUNDLE_LOADER = "$(TEST_HOST)";')
    w(f"\t\t\t\tCODE_SIGN_STYLE = Automatic;")
    w(f"\t\t\t\tCURRENT_PROJECT_VERSION = 1;")
    w(f"\t\t\t\tDEVELOPMENT_TEAM = {DEV_TEAM};")
    w(f"\t\t\t\tGENERATE_INFOPLIST_FILE = YES;")
    w(f"\t\t\t\tMARKETING_VERSION = 1.0;")
    w(f"\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.emoha.desktopAhaanTests;")
    w(f'\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";')
    w(f"\t\t\t\tSWIFT_EMIT_LOC_STRINGS = NO;")
    w(f"\t\t\t\tSWIFT_VERSION = 5.0;")
    w(f'\t\t\t\tTEST_HOST = "$(BUILT_PRODUCTS_DIR)/desktopAhaan.app/$(BUNDLE_EXECUTABLE_FOLDER_PATH)/desktopAhaan";')
    w(f"\t\t\t}};")
    w(f"\t\t\tname = Release;")
    w(f"\t\t}};")

    # UITest target Debug — same shape as unit-test Debug but with
    # ui-testing TEST_TARGET_NAME (not TEST_HOST/BUNDLE_LOADER which
    # are unit-test-only). xcodebuild routes UI tests via a
    # XCTestPlanService that uses TEST_TARGET_NAME to find the host.
    if uitest_sources:
        w(f"\t\t{UITEST_DEBUG_ID} /* Debug */ = {{")
        w(f"\t\t\tisa = XCBuildConfiguration;")
        w(f"\t\t\tbuildSettings = {{")
        w(f"\t\t\t\tCODE_SIGN_STYLE = Automatic;")
        w(f"\t\t\t\tCURRENT_PROJECT_VERSION = 1;")
        w(f"\t\t\t\tDEVELOPMENT_TEAM = {DEV_TEAM};")
        w(f"\t\t\t\tGENERATE_INFOPLIST_FILE = YES;")
        w(f"\t\t\t\tMARKETING_VERSION = 1.0;")
        w(f"\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.emoha.desktopAhaanUITests;")
        w(f'\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";')
        w(f"\t\t\t\tSWIFT_EMIT_LOC_STRINGS = NO;")
        w(f"\t\t\t\tSWIFT_VERSION = 5.0;")
        w(f"\t\t\t\tTEST_TARGET_NAME = desktopAhaan;")
        w(f"\t\t\t}};")
        w(f"\t\t\tname = Debug;")
        w(f"\t\t}};")

        # UITest target Release
        w(f"\t\t{UITEST_RELEASE_ID} /* Release */ = {{")
        w(f"\t\t\tisa = XCBuildConfiguration;")
        w(f"\t\t\tbuildSettings = {{")
        w(f"\t\t\t\tCODE_SIGN_STYLE = Automatic;")
        w(f"\t\t\t\tCURRENT_PROJECT_VERSION = 1;")
        w(f"\t\t\t\tDEVELOPMENT_TEAM = {DEV_TEAM};")
        w(f"\t\t\t\tGENERATE_INFOPLIST_FILE = YES;")
        w(f"\t\t\t\tMARKETING_VERSION = 1.0;")
        w(f"\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.emoha.desktopAhaanUITests;")
        w(f'\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";')
        w(f"\t\t\t\tSWIFT_EMIT_LOC_STRINGS = NO;")
        w(f"\t\t\t\tSWIFT_VERSION = 5.0;")
        w(f"\t\t\t\tTEST_TARGET_NAME = desktopAhaan;")
        w(f"\t\t\t}};")
        w(f"\t\t\tname = Release;")
        w(f"\t\t}};")

    w("/* End XCBuildConfiguration section */")
    w("")

    # ── XCConfigurationList ──
    w("/* Begin XCConfigurationList section */")
    w(f"\t\t{PROJECT_BCL} /* Build configuration list for PBXProject \"desktopAhaan\" */ = {{")
    w(f"\t\t\tisa = XCConfigurationList;")
    w(f"\t\t\tbuildConfigurations = (")
    w(f"\t\t\t\t{PROJ_DEBUG_ID} /* Debug */,")
    w(f"\t\t\t\t{PROJ_RELEASE_ID} /* Release */,")
    w(f"\t\t\t);")
    w(f"\t\t\tdefaultConfigurationIsVisible = 0;")
    w(f"\t\t\tdefaultConfigurationName = Release;")
    w(f"\t\t}};")
    w(f"\t\t{APP_BCL} /* Build configuration list for PBXNativeTarget \"desktopAhaan\" */ = {{")
    w(f"\t\t\tisa = XCConfigurationList;")
    w(f"\t\t\tbuildConfigurations = (")
    w(f"\t\t\t\t{APP_DEBUG_ID} /* Debug */,")
    w(f"\t\t\t\t{APP_RELEASE_ID} /* Release */,")
    w(f"\t\t\t);")
    w(f"\t\t\tdefaultConfigurationIsVisible = 0;")
    w(f"\t\t\tdefaultConfigurationName = Release;")
    w(f"\t\t}};")
    w(f"\t\t{TEST_BCL} /* Build configuration list for PBXNativeTarget \"desktopAhaanTests\" */ = {{")
    w(f"\t\t\tisa = XCConfigurationList;")
    w(f"\t\t\tbuildConfigurations = (")
    w(f"\t\t\t\t{TEST_DEBUG_ID} /* Debug */,")
    w(f"\t\t\t\t{TEST_RELEASE_ID} /* Release */,")
    w(f"\t\t\t);")
    w(f"\t\t\tdefaultConfigurationIsVisible = 0;")
    w(f"\t\t\tdefaultConfigurationName = Release;")
    w(f"\t\t}};")
    if uitest_sources:
        w(f"\t\t{UITEST_BCL} /* Build configuration list for PBXNativeTarget \"desktopAhaanUITests\" */ = {{")
        w(f"\t\t\tisa = XCConfigurationList;")
        w(f"\t\t\tbuildConfigurations = (")
        w(f"\t\t\t\t{UITEST_DEBUG_ID} /* Debug */,")
        w(f"\t\t\t\t{UITEST_RELEASE_ID} /* Release */,")
        w(f"\t\t\t);")
        w(f"\t\t\tdefaultConfigurationIsVisible = 0;")
        w(f"\t\t\tdefaultConfigurationName = Release;")
        w(f"\t\t}};")
    w("/* End XCConfigurationList section */")

    w("\t};")
    w(f"\trootObject = {PROJECT_ID} /* Project object */;")
    w("}")
    w("")

    content = "\n".join(lines)

    # Summary
    print(f"App sources:    {len(app_sources)}")
    print(f"App resources:  {len(app_resources)} + 1 xcassets")
    print(f"Test sources:   {len(test_sources)}")
    print(f"UITest sources: {len(uitest_sources)}")
    print(f"App groups:     {len(app_groups)}")
    print(f"Test groups:    {len(test_groups)}")
    print(f"UITest groups:  {len(uitest_groups)}")
    print(f"Total lines:    {len(lines)}")
    print(f"Output:         {OUTPUT}")

    return content

if __name__ == "__main__":
    content = generate()

    # Back up original
    backup = OUTPUT + ".backup_xcode26"
    if not os.path.exists(backup):
        if os.path.exists(OUTPUT):
            import shutil
            shutil.copy2(OUTPUT, backup)
            print(f"Backed up original to: {backup}")

    with open(OUTPUT, "w") as f:
        f.write(content)

    print("\nDone! project.pbxproj has been regenerated for Xcode 13+ compatibility.")
    print("objectVersion: 55 (was 77)")
    print("Removed: PBXFileSystemSynchronizedRootGroup, Swift 6 settings")
    print("Added: Explicit PBXFileReference for every file")
