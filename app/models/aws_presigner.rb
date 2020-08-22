# frozen_string_literal: true

class AwsPresigner
  def generate_url(private_url)
    target_uri = URI.parse(private_url)
    bucket = target_uri.host.split('.').first
    key = target_uri.path[1..-1]
    signer.presigned_url(
      :get_object,
      bucket: bucket,
      key: key,
      expires_in: 1.week.to_i
    )
  end

  private

  def signer
    @signer ||= Aws::S3::Presigner.new
  end
end
