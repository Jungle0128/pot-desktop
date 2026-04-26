# pnpm install --resolution-only
pnpm install
sed -i "s/#openssl/openssl={version=\"0.10\",features=[\"vendored\"]}/g" src-tauri/Cargo.toml
if [ "$INPUT_TARGET" = "x86_64-unknown-linux-gnu" ]; then
    if [[ "$TAURI_PRIVATE_KEY" == untrusted\ comment:* ]] && [[ -n "$TAURI_KEY_PASSWORD" ]]; then
        pnpm tauri build --target $INPUT_TARGET
    else
        echo "Updater private key is missing or invalid. Building appimage/deb/rpm only."
        pnpm tauri build --target $INPUT_TARGET -b appimage deb rpm
    fi
else
    pnpm tauri build --target $INPUT_TARGET -b deb rpm
fi
