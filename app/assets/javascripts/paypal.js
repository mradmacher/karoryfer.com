function render_paypal(element_id, payment_url, locale, environment) {
  paypal.Button.render({
    env: environment,

    locale: locale,
    style: {
      label: 'buynow',
      size: 'small',
      color: 'gold',
      shape: 'pill',
      branding: true,
    },

    payment: function() {
      return paypal.request.get(payment_url).then(function(data) {
        return data.id;
      });
    },

    onAuthorize: function(data) {
      return paypal.request.post(
        payment_url,
        {
          paymentID: data.paymentID,
          payerID:   data.payerID
        },
        {
          headers: { 'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content') }
        }
      ).then(function() {
        // You can now show a confirmation message to the customer
        $('.paypal-confirmation').removeClass('hidden');
      });
    }

  }, element_id);
}


$(window).load(function() {
  $('.paypal-button').each(function(index) {
    payment_button = $(this)
    render_paypal(
      payment_button.attr('id'),
      payment_button.find('a').attr('href'),
      payment_button.data('locale'),
      payment_button.data('environment')
    );
  })
})
