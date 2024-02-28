# ManaTrends
Gaming analytics
Logo soon

## Description
HTTP system: https://github.com/typhoeus/typhoeus

## Usage
```bash
bundle install
# Normal Mode
bundle exec puma -C config/puma.rb
# Development Mode
bundle exec rerun -- puma -C config/puma.rb
```

## Testing
```bash
bundle exec rspec
```

## Benchmark results Typhoeus vs Hydra
```
Benchmarking individual requests:
Game ID: 440, Status: 200
Game ID: 570, Status: 200
Game ID: 730, Status: 200
Game ID: 620, Status: 200
Game ID: 105600, Status: 200
Game ID: 252950, Status: 200
Game ID: 291550, Status: 200
Game ID: 377160, Status: 200
Game ID: 230410, Status: 200
Game ID: 218620, Status: 200
  0.021487   0.005057   0.026544 (  1.785857)

Benchmarking concurrent requests with Hydra:
Game ID: 440, Status: 200
Game ID: 570, Status: 200
Game ID: 730, Status: 200
Game ID: 620, Status: 200
Game ID: 105600, Status: 200
Game ID: 252950, Status: 200
Game ID: 291550, Status: 200
Game ID: 377160, Status: 200
Game ID: 230410, Status: 200
Game ID: 218620, Status: 200
  0.049003   0.017245   0.066248 (  0.497681)
```

The use of Hydra for concurrent requests resulted in a substantial performance improvement, making the process approximately 3.59 times faster than making individual requests.

### TODO
- [X] Basic Steam Setup
- [ ] Logger Setup
- [X] Database Setup
- [ ] Stormgate API
- [ ] Twitch API