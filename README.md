# Jekyll Avatar

*A Jekyll plugin for rendering GitHub avatars*

[![Build Status](https://travis-ci.org/benbalter/jekyll-avatar.svg)](https://travis-ci.org/benbalter/jekyll-avatar)

Jekyll Avatar makes it easy to add GitHub avatars to your Jekyll site by specifying a username. If performance is a concern, Jekyll Avatar is deeply integrated with the GitHub avatar API, ensuring avatars are cached and load in parallel.

## Installation

Add the following to your site's `Gemfile`:

```ruby
gem 'jekyll-avatar'
```

And add the following to your site's `_config.yml` file:

```yaml
gems:
  - jekyll-avatar
```

## Usage

Simply add the following, anywhere you'd like a user's avatar to appear:

```
{% avatar [USERNAME] %}
```

With `[USERNAME]` being the user's GitHub username:

```
{% avatar hubot %}
```

That will output:

```html
<img class="avatar avatar-small" src="https://avatars3.githubusercontent.com/hubot?v=3&amp;s=40" alt="hubot" width="40" height="40" />
```

### Customizing

You can customize the size of the resulting avatar by passing the size argument:

```
{% avatar hubot size=50 %}
```

That will output:

```html
<img class="avatar" src="https://avatars3.githubusercontent.com/hubot?v=3&amp;s=50" alt="hubot" width="50" height="50" />
```

### Passing the username as variable

You can also pass the username as a variable, like this:

```
{% assign username="hubot" %}
{% avatar {{ username }} %}
```

Or, if the variables is in the page's front matter:

```
{% avatar {{ page.username }} %}
```
