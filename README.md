# RTPEngine

> Docker image with a RTPEngine

![publish to docker](https://github.com/fonoster/rtpengine/workflows/publish%20to%20docker%20hub/badge.svg)

This repository contains a dockerized distribution of RTPEngine 3.x for use in [Fonoster](https://github.com/fonoster/fonoster). For more documentation on how Fonoster images are constructed and how to work with them, please see the [documentation](https://github.com/fonoster/fonoster).

## Available Versions

You can see all images available to pull from Docker Hub via the [Tags](https://hub.docker.com/repository/docker/fonoster/rtpengine/tags?page=1) page. Docker tag names that begin with a "change type" word such as task, bug, or feature are available for testing and may be removed at any time.

> The version is the same of the Asterisk this is image is based on

## Installation

You can clone this repository and manually build it.

```
cd fonoster/rtpengine\:%%VERSION%%
docker build -t fonoster/rtpengine:%%VERSION%% .
```

Otherwise you can pull this image from docker index.

```
docker pull fonoster/rtpengine:%%VERSION%%
```

## Usage Example

The following is a basic example of using this image.

```
docker run -it --net=host \
  -p 8080:8080 \
  -e BIND_HTTP_PORT=8080 \
  -e LOG_LEVEL=8 \
  fonoster/rtpengine
```

## Environment Variables

Environment variables are used in the entry point script to render configuration templates. You can specify the values of these variables during `docker run`, `docker-compose up`, or in Kubernetes manifests in the `env` array.

- `RTPENGINE_PUBLIC_IP` - Host's external IP. If undefined, the container will attempt to guess the host's public IP
- `RTPENGINE_BIND_HTTP_PORT` - The port the container is listening on for HTTP requests. Defaults to `8080`
- `RTPENGINE_BIND_NG_PORT` - The port the container is listening on for NG requests. Defaults to `22222`
- `RTPENGINE_LOG_LEVEL` - Level of verbosity of the logs. Defaults to `7`
- `RTPENGINE_PORT_MIN` - Lower value of port range. Defaults to `10000`
- `RTPENGINE_PORT_MAX` - Upper value of port range. Defalts to `10500`
- `RTPENGINE_CLOUD` - Name of cloud the provided. This will help the container determine its public IP. Acceptable values are: `gcp`, `aws`, `digitalocean`, `azure`, and `*`. Defaults to `*`
- `RTPENGINE_HOMER_ADDR` - Host and port of the HOMER server. If defined, the container will send RTP statistics to the specified HOMER server. Defaults to `nil`
- `RTPENGINE_HOMER_PROTOCOL` - Protocol used to send RTP statistics to the HOMER server. Acceptable values are: `udp` and `tcp`. Defaults to `udp`
- `RTPENGINE_HOMER_ID` - ID of the HOMER server. Defaults to random four digit number.

## Exposed ports

- `8080` - Default HTTP port
- `22222` - Default NG port

> This container requires of "host" mode to do its job. The ports PORT_MIN to PORT_MAX must be open on the host.

## Contributing

Please read [CONTRIBUTING.md](https://github.com/fonoster/fonoster/blob/main/CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Authors

- [Pedro Sanders](https://github.com/psanders)

See also the list of contributors who [participated](https://github.com/fonoster/rtpengine/contributors) in this project.

## License

Copyright (C) 2024 by Fonoster Inc. MIT License (see [LICENSE](https://github.com/fonoster/fonoster/blob/main/LICENSE) for details).
