classdef cnn_class
    properties
        bus_m=6
        bus_f=10
        bus_q=16
        template_no=0
        iter=10
        Ts=0.01

        learn_loop=25
        learn_rate=0.1
    end
    
    methods
        [ A,B,I,x_bnd,u_bnd ] = cnn_template(m,extra_arg);
        [y,y_normal,y_cpu_time] = cnn_system( A,B,I,x_bnd,u_bnd, u, x_0, Ts, iter, gpu_cpu);
        error = cnn_error_calc(y_ideal,y_output);
        
        function cnn=cnn_class(template_no, iter, Ts, learn_loop, learn_rate)
            cnn.template_no=template_no;
            cnn.iter=iter;
            cnn.Ts=Ts;

            cnn.learn_loop=learn_loop;
            cnn.learn_rate=learn_rate;
        end
    end
end

