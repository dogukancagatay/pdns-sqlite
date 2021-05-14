variable "TAG" {
    default = "latest"
}

variable "VERSION_TAG" {
    default = "4.4.1"
}

variable "PDNS_VERSION" {
    default = "4.4.1-1pdns.buster"
}

variable "BUILD_DATE" {
    default = "2021-05-15T00:29:05Z"
}

group "default" {
    targets = [
        "app-amd64",
        "app-armv7"
    ]
}

target "app-amd64" {
    context = "."
    platforms = ["linux/amd64"]
    dockerfile = "Dockerfile"
    args = {
        APP_VERSION = "${VERSION_TAG}"
        PDNS_VERSION = "${PDNS_VERSION}"
        BUILD_DATE = "${BUILD_DATE}"
    }
    tags = [
        "docker.io/dcagatay/pdns-sqlite:${TAG}_amd64",
        "docker.io/dcagatay/pdns-sqlite:${VERSION_TAG}_amd64"
    ]
}

target "app-armv7" {
    context = "."
    platforms = ["linux/arm/v7"]
    dockerfile = "Dockerfile.armv7"
    args = {
        APP_VERSION = "${VERSION_TAG}"
        PDNS_VERSION = "${PDNS_VERSION}"
        BUILD_DATE = "${BUILD_DATE}"
    }
    tags = [
        "docker.io/dcagatay/pdns-sqlite:${TAG}_armv7",
        "docker.io/dcagatay/pdns-sqlite:${VERSION_TAG}_armv7"
    ]
}
