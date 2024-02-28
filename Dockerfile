# Use an official Ruby runtime as a parent image
FROM ruby:3.2.2

# Set the working directory in the container
WORKDIR /usr/src/app

# Install dependencies required for adding a new repository
RUN apt-get update -qq && apt-get install -y apt-transport-https gnupg2 curl

# Add the DataStax repository for the Cassandra C++ driver
RUN curl -fsSL https://downloads.datastax.com/cpp-driver/debian/$(. /etc/os-release; echo $VERSION_CODENAME)/cassandra/v2.17.0/pubkey.gpg | apt-key add - \
  && echo "deb https://downloads.datastax.com/cpp-driver/debian/$(. /etc/os-release; echo $VERSION_CODENAME)/cassandra/v2.17.0 $(. /etc/os-release; echo $VERSION_CODENAME) main" | tee -a /etc/apt/sources.list.d/cassandra-cpp-driver.list

# Update package lists again and install the Cassandra C++ driver
RUN apt-get update -qq && apt-get install -y cassandra-cpp-driver cassandra-cpp-driver-dev

# Copy the current directory contents into the container at /usr/src/app
COPY . .

# Install any needed packages specified in Gemfile
RUN bundle install --verbose

# Make port 9292 available to the world outside this container
EXPOSE 9292

# Define environment variable
ENV RACK_ENV=production

# Start Puma
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
