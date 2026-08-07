# debian/http

Served by Packer's built-in HTTP server to the build VM at
`http://<PACKER_HTTP_ADDR>/<filename>` during the `cloudimg.image` build.

## Vendoring the cloud-init .deb

`scripts/networking.sh` normally fetches a pinned Ubuntu cloud-init `.deb`
from Launchpad to work around missing MAAS bindings in Debian's stock
package (see LP#2011454). If `launchpadlibrarian.net` is unreachable from
your build host, download the file yourself (from any machine that *can*
reach it) and drop it in this directory under the exact name the script
expects:

- Debian 12/13: `cloud-init_23.1.2-0ubuntu0~23.04.1_all.deb`
- Other: `cloud-init_20.1-10-g71af48df-0ubuntu5_all.deb`

`networking.sh` checks here first and only falls back to the direct
Launchpad URL if the file isn't present.
