$(document).ready(function () {
  var options = {
    trigger: 'hover',
    title: 'Why do you need my phone number?',
    content: 'We use your phone number for Two-factor authentication. Two-factor authentication provides an extra layer of security when logging in to secure systems. If you provide a phone number here, you will receive a text message with a pin number to access your account. To skip two-factor authentication and login with just a username and password, leave this field blank. US numbers only.'
  }

  $('#two-factor-phone').popover(options);
});