# supervisord-config
My modular [`supervisord`](http://supervisord.org/) configuration for containers, as outlined in [this blog post](https://leigholiver.com/posts/tips-for-supervisord-config/)

Key features:
- Minimise duplication
- Dynamically set which process groups ("roles") are running
- Ensure that supervisor quits when a process becomes `FATAL`

## Usage
- Download the `supervisor/` directory of this repository
- Modify `supervisor.conf`, `common.conf` and the role definitions as required
- Copy the directory into `/etc/supervisor` of your container image
- Configure your container to run `/etc/supervisor/start.sh` on startup
    - This can either be set as the entrypoint, or called by your entrypoint script
- When starting a container, set the `ROLES` environment variable to choose which roles to run

There are three places for configuration:
- `supervisor.conf` is the base supervisor configuration file
- `common.conf` contains configuration lines which are applied to all processes in every role
- The `roles/` directory contains the role definitions

A role definiton is a [supervisor process configuration](http://supervisord.org/subprocess.html#examples-of-program-configurations) as either:
- A file named `<role>.conf`, containing a single process
- A directory named `<role>`, containing a `*.conf` file for each process to run for the role
    - This structure allows the `common.conf` options to be applied to each process properly

### Using the example
The example in this repo can be run as a Docker image.
To build the image run `docker build -t supervisord-config .`

The [entrypoint script](docker-entrypoint.sh) is configured to fail if no role is specified:
- `docker run -it supervisord-config`

By specifying the `web` role, `nginx` and `php` will be started:
- `docker run -it -e ROLES=web supervisord-config`

And by specifying the `worker` role, the `worker.php` script will be started.
This script will randomly fail, and supervisor will restart it as needed.
- `docker run -it -e ROLES=worker supervisord-config`

Both roles can be set to run in the same container:
- `docker run -it -e ROLES=web,worker supervisord-config`

The worker script can also be configured to fail to start, which will show `nginx` and `php` quitting and the container exiting.
- `docker run -it -e ROLES=web,worker -e FAIL=true supervisord-config`
