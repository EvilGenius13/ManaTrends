# Use an official Ruby runtime as a parent image
FROM ruby:3.2.2

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the current directory contents into the container at /usr/src/app
COPY . .

# Install any needed packages specified in Gemfile
RUN bundle install

# Make port 9292 available to the world outside this container
EXPOSE 9292

# Define environment variable
ENV RACK_ENV=production

# Start Puma
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
