FROM gitpod/workspace-full

USER root

# Update packages
RUN apt-get -y update && apt-get -y dist-upgrade && \
    apt-get -y install curl gnupg build-essential git less nano default-jdk apt-utils

# install gh-cli
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null
RUN apt-get -y update && apt-get -y install gh

USER gitpod

# Install Google Cloud SDK
RUN curl https://sdk.cloud.google.com > install.sh
RUN bash install.sh --disable-prompts
RUN echo 'source $''{HOME}/google-cloud-sdk/path.bash.inc' >> ${HOME}/.bashrc
RUN echo 'source $''{HOME}/google-cloud-sdk/completion.bash.inc' >> ${HOME}/.bashrc
ENV PATH="${GOPATH}/bin:/usr/local/go/bin:${HOME}/google-cloud-sdk/bin:${PATH}"

RUN gcloud components update && gcloud components install app-engine-go && \
    gcloud components install cloud-datastore-emulator && \
    gcloud components install beta
RUN rm install.sh

# Install app-tools
RUN GOPATH=$HOME/go-packages go install -v github.com/qqiao/app-tools@latest

# Install base npm packages
RUN npm i -g npm yarn firebase-tools
