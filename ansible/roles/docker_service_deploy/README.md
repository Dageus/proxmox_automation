# docker_service_deploy

This role helps deploy services into an existing LXC container that already has [Docker](https://www.docker.com/) installed.

The task is pretty simple --- it creates a directory in `opt/` where the `docker-compose.yml` and other relevant files will exist, copies them from the `app_config_path` (where all your docker compose files should be) into the LXC and then deployes them using the [docker_compose_v2](https://docs.ansible.com/projects/ansible/latest/collections/community/docker/docker_compose_v2_module.html) module.

### Necessary vars

- `app_config_path`: The directory path of the services' docker files

- `service_name`: The name of the sub-directory of the service you're going to deploy (it should contain a `docker-compose.yml` file and an optional `.env` file)
