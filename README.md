## Requirements

oras
podman (or docker)

> [!IMPORTANT]
> You will need to replace `mmortari` with your quay org
> You will need to have login (say with robot account) on your system (`~/.docker/config.json`)

## Steps

Push Artifact

```
oras push quay.io/mmortari/projquay-8131:v1 data/artifact.txt
```

Artifact is now `quay.io/mmortari/projquay-8131:v1`

```
podman run --privileged -v ~/.docker/config.json:/root/.docker/config.json:ro -v $(pwd):/test -w /test -it quay.io/buildah/stable
```

Inside the buildah container:

```
buildah build --manifest quay.io/mmortari/projquay-8131:v1-modelcar -f Containerfile .
buildah manifest annotate --subject quay.io/mmortari/projquay-8131:v1 quay.io/mmortari/projquay-8131:v1-modelcar
buildah manifest inspect quay.io/mmortari/projquay-8131:v1-modelcar
buildah manifest push --all quay.io/mmortari/projquay-8131:v1-modelcar
exit
```

Now we have a KServe Modelcar OCI image, pointing to the OCI Artifact via OCI-Dist referrer API.

```
skopeo inspect --raw docker://quay.io/mmortari/projquay-8131:v1-modelcar | jq
oras discover quay.io/mmortari/projquay-8131:v1
Error response from registry: recognizable error message not found: GET "https://quay.io/v2/mmortari/projquay-8131/referrers/sha256:9e58b2f430d3d7be595d84ca4da1f783e25d55dd8c4b554d23baf621a179f0cc": response status code 500: Internal Server Error
```

and same problem while accessing GET to https://quay.io/v2/mmortari/projquay-8131/referrers/sha256:9e58b2f430d3d7be595d84ca4da1f783e25d55dd8c4b554d23baf621a179f0cc
which is the OCI Artifact.
