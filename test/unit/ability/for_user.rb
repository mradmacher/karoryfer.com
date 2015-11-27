module AbilityTest
  module ForUser
    def test_managing_account_is_allowed
      assert @ability.allows?(:read, @account)
      assert @ability.allows?(:write, @account)
      assert @ability.allows?(:read_membership, @account)
      assert @ability.allows?(:write_membership, @account)
    end
  end
end
