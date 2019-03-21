RSpec.describe RubyCiruits do
	it "has a version number" do
    	expect(RubyCiruits::VERSION).not_to be nil
  	end


  	context "when creating a logic AND gate" do
  		AND1 = LogicGates::AND.new(0, 0)
  		AND2 = LogicGates::AND.new(1, 0)
  		AND3 = LogicGates::AND.new(1, 1)

  		it "with 2 inputs (0, 0)" do
	    	expect(AND1.output).to eq(0)
	  	end
	  	
	  	it "with 2 inputs (1, 0)" do
	    	expect(AND2.output).to eq(0)
	  	end
	  	
	  	it "with 2 inputs (1, 1)" do
	    	expect(AND3.output).to eq(1)
	  	end

  	end

  	context "when creating a logic OR gate" do
  		OR1 = LogicGates::OR.new(0, 0)
  		OR2 = LogicGates::OR.new(1, 0)
  		OR3 = LogicGates::OR.new(1, 1)

  		it "with 2 inputs (0, 0)" do
	    	expect(OR1.output).to eq(0)
	  	end
	  	
	  	it "with 2 inputs (1, 0)" do
	    	expect(OR2.output).to eq(1)
	  	end
	  	
	  	it "with 2 inputs (1, 1)" do
	    	expect(OR3.output).to eq(1)
	  	end

  	end
end
