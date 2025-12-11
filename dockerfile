# Creates docker image

#############################################
# Select the OS
FROM flywheel/fsl-base:6.0.1

#############################################
# Install necessary packages
RUN apt-get update \
    && apt-get install -y \
      jq

#############################################
# Setup default flywheel/v0 directory
ENV FLYWHEEL=/flywheel/v0
RUN mkdir -p ${FLYWHEEL}
WORKDIR ${FLYWHEEL}
COPY run ${FLYWHEEL}/run
COPY manifest.json ${FLYWHEEL}/manifest.json

#############################################
# Configure entrypoint
RUN chmod a+x /flywheel/v0/run
ENTRYPOINT ["/flywheel/v0/run"]