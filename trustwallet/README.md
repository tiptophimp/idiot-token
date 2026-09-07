# TrustWallet asset submission

Assets for listing IDIOT in TrustWallet, laid out in TrustWallet's own
repository structure so the folder can be copied straight into a fork of
[trustwallet/assets](https://github.com/trustwallet/assets) without
rearranging anything.

```
trustwallet/blockchains/base/assets/0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1/
    info.json
    logo.png
```

Moved here 2026-09-06 from `E:\Dev\_shared\configs\`, where it was sitting
untracked outside any repo. `_shared` is workspace configuration; token
assets belong with the token project.

## Verified

- `logo.png` is **256 x 256 PNG** — TrustWallet's required dimensions and format
- Folder path matches `blockchains/<chain>/assets/<address>/`
- Address is mixed-case, so it appears to be EIP-55 checksummed (all-lower or
  all-upper would mean it is not)

## Before submitting — one thing to fix first

**`info.json` gives an Ethereum explorer for a Base token.**

```json
"description": "A meme token deployed on the Base blockchain.",
"explorer":    "https://etherscan.io/token/0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1"
```

The canonical Base explorer is **basescan.org**. For a token on Base the
explorer should almost certainly be:

```
https://basescan.org/token/0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1
```

Left unchanged deliberately — this is Ernest's token metadata and not
something to alter without him saying so. But a chain-mismatched explorer
link is the sort of thing a reviewer rejects, so decide before submitting.

## Also worth deciding

Three separate live repos exist for this one token, all pushed within three
minutes of each other on 2026-09-05:

| Repo | Size | Description |
|---|---|---|
| `idiot-token` | 190 MB | Meme Coin Project |
| `stupidiots` | 32 MB | Site source for stupidiots.com |
| `idiotoken` | 50 KB | Site source for idiotoken.com |

Three repos for one token is its own maintenance problem. This submission
went in `idiot-token` because it is project metadata rather than website
content.

## Submitting

Fork `trustwallet/assets`, copy the `blockchains/` tree in, open a PR there.
Check their current requirements before you do — they change, and they
enforce minimum liquidity and holder counts that are not documented in the
folder structure.
