require_relative '../lib/tic_tac_toe'

describe Board do
    let(:board) { Board.new }

    describe "#victory?" do
        it "recognises a horizontal win" do
            board.place_piece("cross", :A1)
            board.place_piece("cross", :B1)
            board.place_piece("cross", :C1)
            expect(board.victory?).to be true
        end
        it "recognises a vertical win" do
            board.place_piece("cross", :A1)
            board.place_piece("cross", :A2)
            board.place_piece("cross", :A3)
            expect(board.victory?).to be true
        end
        it "recognises a diagonal win" do
            board.place_piece("cross", :A1)
            board.place_piece("cross", :B2)
            board.place_piece("cross", :C3)
            expect(board.victory?).to be true
        end
    end
    describe "#stalemate?" do
        it "recognises a stalemate" do
            board.place_piece("nought", :A1)
            board.place_piece("cross", :B1)
            board.place_piece("nought", :C1)
            board.place_piece("cross", :A2)
            board.place_piece("cross", :B2)
            board.place_piece("nought", :C2)
            board.place_piece("nought", :A3)
            board.place_piece("nought", :B3)
            board.place_piece("cross", :C3)
            expect(board.stalemate?).to be true
        end
    end
    describe "place_piece" do
        it "places a piece on the board" do
            board.place_piece("nought", :A2)
            expect(board.squares[:A2].piece).to eql("nought")
        end
    end
end

describe Game do
    let(:game) { Game.new }

    describe '#get_choice' do
        context "when given a valid position" do
            it "returns a valid position" do
                allow(game).to receive(:gets).and_return("A1")
                expect(game.get_choice).to eql(:A1)
            end
        end
        context "when given an invalid position" do
            it "asks for a new position until it is valid" do
                allow(game).to receive(:puts).and_return("")
                allow(game).to receive(:gets).and_return("J9", "B2")
                expect(game.get_choice).to eql(:B2)
            end
        end
    end
    describe '#valid_choice?' do
        context "when a valid position is given" do
            it "returns true" do
                expect(game.valid_choice?("c3")).to be true
            end
        end
        context "when an invalid position is given" do
            it "returns false" do
                expect(game.valid_choice?("j7")).to be false
            end
        end
    end
end