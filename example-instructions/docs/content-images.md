# Content images

A content image is an image of the marketing pages that the content editor (#93) will later manage as an uploaded image: for example the engineer photos and the About photos. Until the content editor exists, these images are kept on Bunny Storage, not in the repository. A photo committed to git stays in its history, and erasure cannot remove it (`docs/personal-data.md`).

- Every file there is public. Never upload a file of the portal: those are downloaded only through the authorized controller (`CODING_STANDARDS.md`, "Private data").
- The visuals (the 3D renders of the marketing pages) are there too, in `visuals/`, and stay there after the content editor exists. How to add one is in `docs/marketing-pages.md`, "Visuals".

## Add an image

1. Prepare one large original, at least twice the largest size the designs show it at. Do not prepare smaller sizes: the content editor's variants will make them.
2. Choose its path: a folder for the kind of image, then the file name, in lowercase letters, digits and hyphens, for example `people/engineer-1.jpg`. Do not put a person's name in the path: the path is written in a view, so it stays in the git history.
3. Upload it. The command prints the image's public URL:

   ```bash
   bin/content-images upload ~/Downloads/photo.jpg people/engineer-1.jpg
   ```

4. Show it in a view with `content_image_url`, with the `width` and `height` of the original:

   ```erb
   <%= image_tag content_image_url("people/engineer-1.jpg"), alt: "", width: 1280, height: 1600 %>
   ```

`bin/content-images list` shows the files in the storage zone, and `bin/content-images list people` the files in one folder.

## Change an image

Never replace a file in place: the CDN (content delivery network) and browsers keep the old file. `bin/content-images upload` refuses a path that already shows a file.

1. Upload the new file with a new path, for example `people/engineer-1-v2.jpg`.
2. Change the path in the view.
3. Delete the old file when production no longer uses it.

## Delete an image

1. Delete the file from the storage zone:

   ```bash
   bin/content-images delete people/engineer-1.jpg
   ```

2. Purge the image's URL from the pull zone's cache in the Bunny dashboard. Without this, the CDN can still show the file.
3. For an erasure request, check that the URL now answers 404.

## Setup

One storage zone and one pull zone serve local development, dev and production: the content is the same everywhere.

| What | Value |
| --- | --- |
| Storage zone | `sample-assets-tmp`, main region Frankfurt (API host `storage.bunnycdn.com`) |
| Pull zone | `sample-assets-tmp`, with the storage zone as its origin |
| Public address | `https://sample-assets.example-cdn.net` |

- **`CONTENT_IMAGES_URL`** is the public address. The app builds every image URL from it. Development has it in `.env.development`, and `.env.test` sets an example host, because specs make no network calls. The Dokku apps do not read these files, and production does not boot without the variable (`RequiredEnv::NAMES`), so set it on both: `dokku config:set <app> CONTENT_IMAGES_URL=https://sample-assets.example-cdn.net`.
- **`BUNNY_STORAGE_URL`** is the Bunny Storage API address of the storage zone: the host of its region, then its name. Only `bin/content-images` reads it, so it is in `.env.development`.
- **`BUNNY_STORAGE_PASSWORD`** is the storage zone's password, from "FTP & API Access" of the storage zone in the Bunny dashboard. It allows uploads and deletes. Only `bin/content-images` reads it; the Dokku apps do not need it. In development it comes from 1Password (README, "1Password"). Without 1Password access, add it to `.env.local`.
- `bin/content-images` is a small wrapper around `curl` and the [Bunny Storage API](https://bunny.net/docs/storage/http).
- The Content Security Policy is not built yet. When it is, its `img-src` must allow the host of `CONTENT_IMAGES_URL`.

## Why Bunny, its cost and its end

- **Reason:** Bunny gives public URLs behind a CDN at once. The bucket of "Object storage for files" (#72) is private by design.
- **Rejected free alternative:** the files in the repository. Git history keeps a photo of a person for good, and large originals make every clone larger.
- **Cost:** storage $0.01 per GB each month and traffic $0.01 per GB in Europe and North America, with a minimum of $1 each month (bunny.net, November 2026). With a few images, the cost is the minimum.
- **End:** when the content editor exists, staff upload each content image to it, and the content images are deleted from the storage zone. The visuals stay, so the zones, the variables, `bin/content-images` and `content_image_url` stay for them. The zone's name, `sample-assets-tmp`, may then change to a new zone.
