RSpec.describe Iso15924 do
  it "has a version number" do
    expect(Iso15924::VERSION).not_to be nil
  end

  it "has codes of ISO-15924" do
    expect(Iso15924.codes.length).to be > 0
  end

  it "should be uniq" do
    expect(Iso15924.codes.length).to be Iso15924.codes.uniq.length
  end

  it "should be immutable" do
    expect { Iso15924.data["Adlm"] = {"custom": "data"} }.to raise_error(FrozenError)
    expect { Iso15924.data["Adlm"]["numeric"] = 999 }.to raise_error(FrozenError)
  end

  it "validate code" do
    expect(Iso15924.valid?("Adlm")).to be true
    expect(Iso15924.valid?("XYZ")).to be false
  end
end
