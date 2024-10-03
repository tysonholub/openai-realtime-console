create_env:
    #!/bin/bash

    set -euxo pipefail

    api_key=$(aws ssm get-parameter --with-decryption --name="/openai/api-key" | jq -r '.Parameter.Value')
    echo "OPENAI_API_KEY='$api_key'" > .env


build:
    #!/bin/bash

    set -euxo pipefail

    docker build -t openai-realtime-console .


run_client: (build)
    #!/bin/bash

    set -euxo pipefail

    docker run --rm -it \
        -v ./src:/app/src \
        -p 3000:3000 \
        --net host \
        openai-realtime-console \
        npm start


run_server: (create_env)(build)
    #!/bin/bash

    set -euxo pipefail

    docker run --rm -it \
        -v ./relay-server:/app/relay-server \
        --env-file .env \
        -p 8081:8081 \
        --net host \
        openai-realtime-console \
        npm run relay