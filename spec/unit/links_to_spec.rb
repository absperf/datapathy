require 'spec_helper'

describe "#links_to" do

  before do
    class Team
      include Datapathy::Model
      def self.adapter; Datapathy.adapters[:memory]; end
      persists :name
      links_to_collection :players
    end

    class Player
      include Datapathy::Model
      def self.adapter; Datapathy.adapters[:memory]; end
      persists :name
      links_to :team
    end

    @team   = Team.create(   :name => "Colts",          :players_href => "/players" )
    @player = Player.create( :name => "Peyton Manning", :team_href =>    @team.href )
  end

  describe 'collection resource' do
    describe "the persisted attributes" do
      subject { Team.attributes }
      it { should include(:players_href) }
    end

    describe "the model" do
      subject { @team }
      it { should respond_to(:players) }
    end

    describe "the association" do
      subject { @team.players }
      it { should be_a(Datapathy::Collection) }
    end

    describe "the associated collection model" do
      subject { @team.players.model }
      it { should be(Player) }
    end

  end

  describe 'single resource' do
    describe "the persisted attributes" do
      subject { Player.attributes }
      it { should include(:team_href) }
    end

    describe "the model" do
      subject { @player }
      it { should respond_to(:team) }
      it { should respond_to(:team=) }
    end

    describe "the association" do
      subject { @player.team }
      it { should be_a(Datapathy::Model) }
      it { should == @team }
    end

    describe "re-assignment" do
      before do
        @other_team = Team.create( :name => "Ol Miss")
        @player.team = @other_team
      end

      it "should update the association" do
        @player.team.should == @other_team
      end

      it "should update the associated href" do
        @player.team_href.should == @other_team.href
      end
    end

  end

end

