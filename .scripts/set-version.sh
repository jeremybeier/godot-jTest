#!/bin/bash
new_version=$1
sed -i "s/config\/version=\"[a-zA-Z0-9_\.\-]*\"/config\/version=\"${new_version}\"/g" project.godot
sed -i "s/version=\"[a-zA-Z0-9_\.\-]*\"/version=\"${new_version}\"/g" addons/j_test/plugin.cfg
