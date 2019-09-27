FROM maven:3-jdk-8-slim

ENV TOTALCROSS3_HOME=/opt/TotalCross5
ARG TC_RELEASE=5.1/TotalCross-5.1.3.zip

# Download and install system deps
RUN \
  export ACCESSIBILITY_PROPERTIES_FILE='/etc/java-8-openjdk/accessibility.properties' && \
  touch ${ACCESSIBILITY_PROPERTIES_FILE} && \
  sed -i \
  's/assistive_technologies=org.GNOME.Accessibility.AtkWrapper/#assistive_technologies=org.GNOME.Accessibility.AtkWrapper/g' \
  ${ACCESSIBILITY_PROPERTIES_FILE} && \
  apt-get update -qq && \
  apt-get install -qy curl unzip

# Download TotalCross SDK
WORKDIR /opt
RUN curl \
  -fL https://s3-us-west-2.amazonaws.com/totalcross-release/${TC_RELEASE} \
  -o ./tc5.zip && \
  unzip -q tc5.zip && \
  rm tc5.zip

# Change to target application directory
WORKDIR /app
CMD ["mvn", "package", "-X"]
