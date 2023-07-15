
	signal gpo1 : std_logic_vector(2*busWidth-1 downto 0);--bram:bram_address,bram_data_in
	signal gpi1 : std_logic_vector(2*busWidth-1 downto 0);--template_data_out,bram_data_out


				when 0 =>
				
				when 1 =>
					cacheWidth<=control_data_in;
				when 2 =>
					cacheHeight<=control_data_in;
				when 3 =>
					Ts<=control_data_in;
				when 4 =>
					iter_cnt<=control_data_in;
				when 5 =>
					learn_rate<=control_data_in;
				when 6 =>
					rand_gen<=control_data_in(0);
				when 7 =>
					x_fill_val<=control_data_in;
				when 8 =>
					cnn_rst<=control_data_in(0);
					state_mode<=control_data_in(modeWidth downto 1);
				when others =>