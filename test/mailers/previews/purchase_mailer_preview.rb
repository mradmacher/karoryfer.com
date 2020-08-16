# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/purchase_mailer
class PurchaseMailerPreview < ActionMailer::Preview
  def confirmation
    release = Release.where(format: 'cd').first
    purchase = Purchase.where(release: release).first
    PurchaseMailer.with(
      email: 'test@example.com',
      name: 'Tonny'
    ).confirmation(purchase.release, purchase.reference_id)
  end
end
