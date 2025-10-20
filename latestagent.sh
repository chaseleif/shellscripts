#! /usr/bin/env bash

# launches chromium with latest user-agent
# made for use in exo-open with cmd (replacing path)
# $(pwd)/latest.sh %U
# would work standalone as well

# location for the previously found useragent
agentconf="${HOME}/.config/useragent"
# a useragent stored within the past 2 weeks
useragent="$(find "$agentconf" -type f -mtime -14)"
# if we have a recent useragent then use this one
[ -f "$useragent" ] && useragent="$(cat "$useragent")"
# otherwise get a new one and update $agentconf
if [ -z "$useragent" ] ; then
  # get the latest agent from whatismybrowser.com
  a=$(curl -Gs \
      https://www.whatismybrowser.com/guides/the-latest-user-agent/chrome)
  # slice out the agent string
  useragent="$(echo "$a" |
                fgrep -e "Latest Chrome" -e '<span class="code">' |
                sed -E 's/^ *//;s/(<\/.*>)$//;s/^(<.*>)//' |
                grep "Linux" | sed -n '2 p')"
  # unset the useragent if it isn't valid
  echo "$useragent" | grep -q "Linux" || unset useragent
  # store the useragent for next time
  [ -n "$useragent" ] && echo "$useragent" > "$agentconf"
fi

# launch chromium with/out our useragent (and all other args)
if [ -z "$useragent" ] ; then
  chromium "$@"
else
  chromium --user-agent="$useragent" "$@"
fi
