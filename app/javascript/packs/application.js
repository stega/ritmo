// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

import "bootstrap/dist/js/bootstrap"
import "bootstrap/dist/css/bootstrap"


Rails.start()
Turbolinks.start()
ActiveStorage.start()

require("trix")
require("@rails/actiontext")

import jstz from 'jstz'

function setCookie(name, value) {
  var expires = new Date()
  expires.setTime(expires.getTime() + (24 * 60 * 60 * 1000))
  document.cookie = name + '=' + value + ';expires=' + expires.toUTCString()
}

// Rails doesn't support every timezone that Intl supports
function findTimeZone() {
  const oldIntl = window.Intl
  try {
    window.Intl = undefined
    const tz = jstz.determine().name()
    window.Intl = oldIntl
    return tz
  } catch (e) {
    // sometimes (on android) you can't override intl
    return jstz.determine().name()
  }
}

const timezone = findTimeZone()
setCookie("timezone", timezone)
