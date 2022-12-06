
# project_name="backend"
# _remote_image_repo="502515897402.dkr.ecr.eu-central-1.amazonaws.com/nba-fantasy.${project_name}:latest"
# pushd ${project_name}
# docker build \
#     -t ${project_name} \
#     --build-arg project_name=${project_name} \
#     .
# docker tag ${project_name}:latest ${_remote_image_repo}
# aws ecr get-login-password --region eu-central-1 --profile personal_terraform | docker login --username AWS --password-stdin 502515897402.dkr.ecr.eu-central-1.amazonaws.com
# docker push ${_remote_image_repo}

ARG project_name
ARG function_dir="/function"

FROM rust as build
ARG project_name function_dir
ENV YAHOO_OAUTH_CLIENT_ID="dj0yJmk9ZWdRSG4yNld5ZzFVJmQ9WVdrOWRsUk9jRUprTnpRbWNHbzlNQT09JnM9Y29uc3VtZXJzZWNyZXQmc3Y9MCZ4PTcz"
ENV YAHOO_OAUTH_CLIENT_SECRET="72eb471a0c41b9a9d13fec5bfe1500c156df4ac1"

WORKDIR /usr/src/app
COPY ./src ./src
COPY ./.env ./.env
COPY ./Cargo.toml ./Cargo.toml
COPY ./Cargo.lock ./Cargo.lock
RUN cargo install --path . --root ${function_dir}


# FROM scratch
FROM gcr.io/distroless/cc-debian10
ARG project_name function_dir
# ENV RUST_BACKTRACE=1
COPY --from=build ${function_dir}/bin/${project_name} /app
CMD ["/app"]
