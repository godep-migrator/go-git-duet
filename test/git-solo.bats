#!/usr/bin/env bats

load test_helper

@test "sets the git user name" {
  git solo -q jd
  run git config user.name
  assert_success 'Jane Doe'
}

@test "sets the git user email" {
  git solo jd
  run git config user.email
  assert_success 'jane@hamsters.biz.local'
}

@test "caches the git user name as author name" {
  git solo -q jd
  run git config "$GIT_DUET_CONFIG_NAMESPACE.git-author-name"
  assert_success 'Jane Doe'
}

@test "caches the git user email as author email" {
  git solo -q jd
  run git config "$GIT_DUET_CONFIG_NAMESPACE.git-author-email"
  assert_success 'jane@hamsters.biz.local'
}

@test "looks up external email" {
  skip "TODO"
  GIT_DUET_EMAIL_LOOKUP_COMMAND=$GIT_DUET_TEST_LOOKUP git solo -q jd
  run git config "$GIT_DUET_CONFIG_NAMESPACE.git-author-email"
  assert_success 'jane_doe@lookie.me.local'
}

@test "uses custom email template when provided" {
  skip "TODO"
  local suffix=$RANDOM

  set_custom_email_template "awk '{ print tolower(substr(\$1, 1, 1)) \".\" tolower(substr($2, 1))} \"$suffix@mompopshop.local\""

  git solo -q zp
  run git config "$GIT_DUET_CONFIG_NAMESPACE.git-author-email"
  assert_success "zubazp$suffix@mompopshop.local"

  clear_custom_email_template
}
