# Use an official Ubuntu base image
FROM ubuntu:latest

# Install Ruby, Python, and necessary packages
RUN apt-get update -qq && \
    apt-get install -y ruby-full build-essential git libvips-dev pkg-config python3 python3-pip python3-dev curl libyaml-dev

# Install Ruby gems and Python packages
RUN gem install bundler && \
    python3 -m pip install --upgrade pip && \
    pip install yfinance

# Confirm Python and Ruby versions
RUN which python3 && python3 --version && \
    which ruby && ruby --version

# Set the working directory for your Rails app
WORKDIR /rails

# Copy your Gemfile and Gemfile.lock into the image
COPY Gemfile Gemfile.lock ./

# Run bundle install to install gems
RUN bundle install

# Copy the rest of your application code
COPY . .

# Set an environment variable to execute Rails in development mode
ENV RAILS_ENV=development

# Expose port 3000 for the Rails server
EXPOSE 3000

# Run the Rails server as default command
CMD ["rails", "server", "-b", "0.0.0.0"]
