class AlphaProtocol
  def packet_ids
    {
      :connection_request 		  => 0x01,
      :disconnect		 		        => 0x02,
      :connection_response 		  => 0x03,
      :player_data 				      => 0x04,
      :inventory_data			      => 0x05,
      :world_request			      => 0x06,
      :world_data				        => 0x07,
      :request_tile_block		    => 0x08,
      :statusbar_text           => 0x09,
      :send_tile_row			      => 0x0A,
      :send_tile_confirm		    => 0x0B,
      :receiving_player_joined 	=> 0x0C,
      :player_state_update		  => 0x0D,
      :synch_begin				      => 0x0E,
      :update_players			      => 0x0F,
      :player_health_update     => 0x10,
      :tile_modification        => 0x11,
      :time_update              => 0x12,
      :door_update              => 0x13,
      :tile_square              => 0x14,
      :item_info                => 0x15,
      :item_owner_info          => 0x16,
      :npc_info                 => 0x17,
      :strike_npc               => 0x18,
      :player_chat              => 0x19,
      :strike_player            => 0x1A,
      :projectile               => 0x1B,
      :damage_npc               => 0x1c,
      :kill_projectile          => 0x1d,
      :player_pvp_change        => 0x1e,
      :open_chest               => 0x1f,
      :chest_item               => 0x20,
      :player_chest_update      => 0x21,
      :kill_tile                => 0x22,
      :heal_player              => 0x23,
      :enter_zone               => 0x24,
      :password_request         => 0x25,
      :password_response        => 0x26,
      :item_owner_update        => 0x27,
      :npc_talk                 => 0x28,
      :player_ball_swing        => 0x29,
      :player_mana_update       => 0x2a,
      :player_use_mana_update   => 0x2b,
      :kill_player_pvp          => 0x2c,
      :player_join_party        => 0x2d,
      :read_sign                => 0x2e,
      :write_sign               => 0x2f,
      :flow_liquid              => 0x30,
      :send_spawn               => 0x31,
      :player_buffs             => 0x32,
      :summon_skeletron         => 0x33,
      :chest_unlock             => 0x34,
      :npc_add_buffs            => 0x35,
      :npc_buffs                => 0x36,
      :player_add_buff          => 0x37,
      :npc_name                 => 0x38,
      :world_balance            => 0x39,
      :play_harp                => 0x3a,
      :hit_switch               => 0x3b,
      :npc_home                 => 0x3c
    }
  end
  def packet_components
    {
      :connection_request => { :version => :string },
      :disconnect => { :message => :string },
      :connection_response => { :player_slot => :byte },
      :player_data => { :player_slot => :byte, :hair_style => :byte, :gender=>:byte, :hair_color => :color, :skin_color => :color, :eye_color => :color, :shirt_color => :color, :undershirt_color => :color, :pants_color => :color, :shoe_color => :color, :difficulty => :byte, :player_name => :string },
      :inventory_data => { :player_slot => :byte, :inventory_slot => :byte, :item_stack => :byte, :item_prefix=>:byte, :item_id=>:int16 },
      :world_request => {},
      :world_data => {:game_time=>:int32, :day_time=>:byte, :moon_phase=>:byte, :blood_moon => :byte, :map_width=>:int32, :map_height=> :int32, :spawn_tile_x => :int32, :spawn_tile_y => :int32, :ground_level => :int32, :rock_level => :int32, :world_id => :int32, :flags => :byte, :world_name => :string },
      :player_health_update => { :player_slot=>:byte, :current_health =>:int16, :max_health => :int16 },
      :player_mana_update => { :player_slot=>:byte, :current_mana =>:int16, :max_mana => :int16 },
      :player_buffs => { 
        :player_slot=>:byte, 
        :buff1=>:byte, 
        :buff2=>:byte, 
        :buff3=>:byte, 
        :buff4=>:byte, 
        :buff5=>:byte, 
        :buff6=>:byte, 
        :buff7=>:byte, 
        :buff8=>:byte, 
        :buff9=>:byte, 
        :buff10=>:byte },
      :request_tile_block => { :spawn_x => :int32, :spawn_Y => :int32 },
      :send_spawn => {},
      :send_tile_row => { :width => :int16, :tile_x => :int32, :tile_y => :int32, :flags=>:byte_array, :amount => :int16 },
      :statusbar_text => { :num_msg => :int32, :message => :string }
    }
  end
end