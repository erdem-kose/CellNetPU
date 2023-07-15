function [ A,B,I,x_bnd,u_bnd ] = cnn_template(m,extra_arg)
    % source is CNN: A Paradigm for Complexity - Leon O. Chua - Series A
    % Vol 31 World Scientific Series on Nonlinear Science
    %
    % x_0=0 if it is not mentioned
    % if n is
    % 0:fill-black template
    % 1:edge detection (binary)
    % 2:edge detection (gray image to binary)
    % 3:corner detection (gray image to binary)
    % 4:copy u to x
    % 5:threshold (gray image) extra_arg:-1 to 1 threshold value
    % 6:point extraction (binary image)
    % 7:point removal (binary image)
    % 8:logic not (binary image)
    % 9:logic and (binary image) x_0=another binary image
    % 10:logic or (binary image) x_0=another binary image
    % 11:erosion (binary image) extra_arg:3 to 3 binary shape
    % 12:dilation (binary image) extra_arg:3 to 3 binary shape
    % 13:translation (binary image) extra_arg:numpad directions
    % 14: directional edge detection (binary) x_0=input image ; extra_arg:numpad directions

    switch (m)
        case 0
            % 0:fill-black template
            A=[0 0 0; 0 2 0; 0 0 0];
            B=[0 0 0; 0 0 0; 0 0 0];
            I=-4;
            x_bnd=0;%boundaries
            u_bnd=0;%boundaries
        case 1
            % 1:edge detection (binary)
            A=[0 0 0; 0 1 0; 0 0 0];
            B=[-1 -1 -1; -1 8 -1; -1 -1 -1];
            I=-1;
            x_bnd=0;%boundaries
            u_bnd=0;%boundaries
        case 2
            % 2:edge detection (gray image to binary)
            A=[0 0 0; 0 2 0; 0 0 0];
            B=[-1 -1 -1; -1 8 -1; -1 -1 -1];
            I=-0.5;
            x_bnd=0;%boundaries
            u_bnd=0;%boundaries
        case 3
            % 3:corner detection (gray image to binary)
            A=[0 0 0; 0 2 0; 0 0 0];
            B=[-1 -1 -1; -1 8 -1; -1 -1 -1];
            I=-8.5;
            x_bnd=0;%boundaries
            u_bnd=0;%boundaries
        case 4
            % 4:copy u to x
            A=[0 0 0; 0 0 0; 0 0 0];
            B=[0 0 0; 0 1 0; 0 0 0];
            I=0;
            x_bnd=0;%boundaries
            u_bnd=-1;%boundaries
        case 5
            % 5:threshold (gray image)
            A=[0 0 0; 0 2 0; 0 0 0];
            B=[0 0 0; 0 0 0; 0 0 0];
            I=extra_arg;
            x_bnd=0;%boundaries
            u_bnd=-1;%boundaries
        case 6
            % 6:point extraction (binary image)
            A=[0 0 0; 0 1 0; 0 0 0];
            B=[-1 -1 -1; -1 1 -1; -1 -1 -1];
            I=-8;
            x_bnd=1;%boundaries
            u_bnd=1;%boundaries
        case 7
            % 7:point removal (binary image)
            A=[0 0 0; 0 1 0; 0 0 0];
            B=[1 1 1; 1 8 1; 1 1 1];
            I=-1;
            x_bnd=1;%boundaries
            u_bnd=-1;%boundaries
        case 8
            % 8:logic not (binary image)
            A=[0 0 0; 0 1 0; 0 0 0];
            B=[0 0 0; 0 -2 0; 0 0 0];
            I=0;
            x_bnd=0;%boundaries
            u_bnd=0;%boundaries
        case 9
            % 9:logic and (binary image)
            A=[0 0 0; 0 2 0; 0 0 0];
            B=[0 0 0; 0 1 0; 0 0 0];
            I=-1;
            x_bnd=0;%boundaries
            u_bnd=0;%boundaries
        case 10
            % 10:logic or (binary image)
            A=[0 0 0; 0 2 0; 0 0 0];
            B=[0 0 0; 0 1 0; 0 0 0];
            I=1;
            x_bnd=0;%boundaries
            u_bnd=0;%boundaries
        case 11
            % 11:erosion (binary image)
            A=[0 0 0; 0 2 0; 0 0 0];
            if size(extra_arg)==[3,3]
                B=extra_arg;
            else
                B=[0 1 0; 1 1 1; 0 1 0];
            end
            I=-4.5;
            x_bnd=1;%boundaries
            u_bnd=-1;%boundaries
        case 12
            % 12:dilation (binary image)
            A=[0 0 0; 0 2 0; 0 0 0];
            if size(extra_arg)==[3,3]
                B=extra_arg;
            else
                B=[0 1 0; 1 1 1; 0 1 0];
            end
            I=4.5;
            x_bnd=-1;%boundaries
            u_bnd=-1;%boundaries
        case 13
            % 13:translation (binary image)
            A=[0 0 0; 0 1 0; 0 0 0];
            switch (extra_arg)
                case 1
                    B=[0 0 0; 0 0 0; 1 0 0]; %for diagonal down and left
                case 2
                    B=[0 0 0; 0 0 0; 0 1 0]; %for down
                case 3
                    B=[0 0 0; 0 0 0; 0 0 1]; %for diagonal down and right
                case 4
                    B=[0 0 0; 1 0 0; 0 0 0]; %for left
                case 6
                    B=[0 0 0; 0 0 1; 0 0 0]; %for right
                case 7
                    B=[1 0 0; 0 0 0; 0 0 0]; %for diagonal up and left
                case 8
                    B=[0 1 0; 0 0 0; 0 0 0]; %for up
                case 9
                    B=[0 0 1; 0 0 0; 0 0 0]; %for diagonal up and right
                otherwise
                    B=[0 0 0; 0 1 0; 0 0 0]; %no movement
            end
            I=0;
            x_bnd=0;%boundaries
            u_bnd=-1;%boundaries
        case 14
            % 14: directional edge detection (binary)
            A=[0 0 0; 0 1 0; 0 0 0];
            switch (extra_arg)
                case 1
                    B=[0 0 1; 0 1 0; -1 0 0]; %for diagonal down and left
                case 2
                    B=[0 1 0; 0 1 0; 0 -1 0]; %for down
                case 3
                    B=[1 0 0; 0 1 0; 0 0 -1]; %for diagonal down and right
                case 4
                    B=[0 0 0; -1 1 1; 0 0 0]; %for left
                case 6
                    B=[0 0 0; 1 1 -1; 0 0 0]; %for right
                case 7
                    B=[-1 0 0; 0 1 0; 0 0 1]; %for diagonal up and left
                case 8
                    B=[0 -1 0; 0 1 0; 0 1 0]; %for up
                case 9
                    B=[0 0 -1; 0 1 0; 1 0 0]; %for diagonal up and right
                otherwise
                    B=[0 0 0; 0 -1 0; 0 0 0]; %no edges
            end
            I=-2;
            x_bnd=0;%boundaries
            u_bnd=0;%boundaries
        otherwise
            % otherwise:copy u to x
            A=[0 0 0; 0 0 0; 0 0 0];
            B=[0 0 0; 0 1 0; 0 0 0];
            I=0;
            x_bnd=0;%boundaries
            u_bnd=-1;%boundaries
    end
end

