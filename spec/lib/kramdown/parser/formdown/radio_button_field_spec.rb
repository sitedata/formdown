require 'spec_helper'

describe Kramdown::Parser::Formdown do
  context "regexp" do
    context "RADIO_BUTTON_FIELD_START" do
      subject { Kramdown::Parser::Formdown::RADIO_BUTTON_FIELD_START }
      it "matches () for start of radio button" do
        expect("(*) One".match(subject).captures).to match([])
      end
    end

    context "RADIO_BUTTON_FIELD_LABEL" do
      subject { Kramdown::Parser::Formdown::RADIO_BUTTON_FIELD_LABEL }

      it "matches radio button label to end of line" do
        expect(" One\n Two ()".match(subject).captures).to match([" One"])
      end

      it "matches radio button label to next radio button" do
        expect(" One () Two ()".match(subject).captures).to match([" One "])
      end
    end
  end

  context "radio button" do
    subject { html 'radio.fmd' }
    let(:options) do 
      ['Eat a potato', 'Bang my head against the wall', 'Do jumping jacks']
    end

    context "single line" do
      it "renders radio button input" do
        options.each.with_index do |option, idx|
          expect(subject).to include(%(<input type="radio" id="radio_0_#{idx}" name="radio_0"></input>))
        end
      end
      it "renders label" do
        options.each.with_index do |option, idx|
          expect(subject).to include(%(<label for="radio_0_#{idx}">#{option}</label>))          
        end
      end

      # TODO - Group radio buttons and infer some sort of name that can
      # be mapped back into the document... like `radio-#{radio_instance}`
      # where `seq` monotonically increases per named radio button group.
      #
      # TODO - Does `radio[0]` blow up Sinatra/Rails style parsers? Should it be
      # radio_0?

      # it "renders radio button name" do
      #   pending "parse multiple lines of radio buttons"
      #   expect(subject).to include('<input type="radio" name="radio[0]" id="radio_0_0"></input>')
      # end
      # # TODO - Name radio buttons based on the instance of the group AND the sequence of the
      # # radio button (e.g. is it the first or last option to choose from?)
      # it "renders labels" do
      #   pending "render labels"
      #   expect(subject).to include('<label for="radio_0_0">Eat a potato</label>')
      # end
      # it "is checked" do
      #   pending "check forms with *, x, or X"
      #   expect(subject).to include('<input type="radio" name="radio[0]" id="radio_0_1" checked></input>')
      # end
    end
  end

  context "formset" do
    subject { html 'radio.fmd' }
    it "is in formset" do
      expect(subject).to match(/<fieldset name="fieldset_0">(.+?)<\/fieldset>/m)
    end
  end
end