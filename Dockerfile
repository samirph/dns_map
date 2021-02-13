FROM ruby:2.7.2
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /dns_map
COPY Gemfile /dns_map/Gemfile
COPY Gemfile.lock /dns_map/Gemfile.lock
RUN bundle install
COPY . /dns_map

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]