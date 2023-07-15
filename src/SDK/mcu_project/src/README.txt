
	signal gpo1 : std_logic_vector(2*busWidth-1 downto 0);--bram:bram_address,bram_data_in
	signal gpo2 : std_logic_vector(2*busWidth-1 downto 0);--template:template_address,template_data_in
	signal gpo3 : std_logic_vector(2*busWidth-1 downto 0);--control address/control value
	signal gpi1 : std_logic_vector(2*busWidth-1 downto 0);--template_data_out,bram_data_out
	signal gpi2 : std_logic_vector(2*busWidth-1 downto 0);--rand_num/ready
	signal gpi3 : std_logic_vector(2*busWidth-1 downto 0);--error


				when 0 =>
				
				when 1 =>
					imageWidth<=control_data_in;
				when 2 =>
					imageHeight<=control_data_in;
				when 3 =>
					Ts<=control_data_in;
				when 4 =>
					iter_cnt<=control_data_in;
				when 5 =>
					template_no<=control_data_in;
				when 6 =>
					learn_rate<=control_data_in;
				when 7 =>
					cnn_rst<=control_data_in(0);
					state_mode<=control_data_in(modeWidth downto 1);
				when 8 =>
					interface_bram_we<=control_data_in(0 downto 0);
				when 9 =>
					template_we<=control_data_in(0 downto 0);
				when 10 =>
					bram_x_location<=control_data_in;
				when 11 =>
					bram_u_location<=control_data_in;
				when 12 =>
					bram_ideal_location<=control_data_in;
				when 13 =>
					bram_error_location<=control_data_in;
				when others =>