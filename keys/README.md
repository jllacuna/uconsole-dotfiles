# keys

Public keys used as trust anchors by `.chezmoiscripts`.

Not under `home/`, so chezmoi never deploys anything here as a dotfile.

## `age-sigsum-key.pub`

The [Ed25519](https://en.wikipedia.org/wiki/EdDSA) SSH public keys [FiloSottile/age](https://github.com/FiloSottile/age) signs its release binaries with. See [age's SIGSUM.md](https://github.com/FiloSottile/age/blob/main/SIGSUM.md). Used with `sigsum-verify` to verify each release's [Sigsum](https://www.sigsum.org/) proof.

Committed here deliberately: a trust anchor has to be fixed independently of the channel it's verifying, or the verification is circular.

If age ever rotates its signing keys, update this file by hand (and diff it against the source in `age`'s repo before committing). Don't automate refetching it.
