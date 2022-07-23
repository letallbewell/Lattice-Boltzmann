N = 2^8;
dx = 1/(N-1);
dt = 10^-2;
c = dx/dt;
u0 = 0.1;
T = 20;

% Initialze f, velocity and density
f = zeros(N,N,9);
rho = zeros(N,N);
u = zeros(N,N);
v = u;
feq = f;


x = linspace(0,1,N);
[xx,yy] = meshgrid(x,x);


tau = 1.5;  
nu = (2*tau-1)*dx^2/(6*dt);
Re = u0/nu; %u0=nu*Re;  

e = [0 0;1 0;0 1;-1 0;0 -1;1 1;-1 1;-1 -1;1 -1;];
w = [4/9,1/9,1/9,1/9,1/9,1/36,1/36,1/36,1/36];

% Initialize f
for i=1:N
    for j=1:N
         f(i,j,:)=w;
    end
end


rho=sum(f,3);
rho(1,:)=(1/(1-0.1))*(f(1,:,1)+f(1,:,2)+f(1,:,5)+2*(f(1,:,4)+f(1,:,7)+f(1,:,8)));

u=(c./rho).*(e(2,1).*f(:,:,2)+e(3,1)*f(:,:,3)+e(4,1)*f(:,:,4)+e(5,1)*f(:,:,5)+e(6,1)*f(:,:,6)+e(7,1)*f(:,:,7)+e(8,1)*f(:,:,8)+e(9,1)*f(:,:,9));
    
v=(c./rho).*(e(2,2).*f(:,:,2)+e(3,2)*f(:,:,3)+e(4,2)*f(:,:,4)+e(5,2)*f(:,:,5)+e(6,2)*f(:,:,6)+e(7,2)*f(:,:,7)+e(8,2)*f(:,:,8)+e(9,2)*f(:,:,9));

t = 0;
step = 0;

while t<T
    
    % Stream

    f(2:N,1:N,2)=f(1:N-1,1:N,2);
    
    f(1:N,2:N,3)=f(1:N,1:N-1,3);
    
    f(1:N-1,1:N,4)=f(2:N,1:N,4);
    
    f(1:N,1:N-1,5)=f(1:N,2:N,5);
    
    f(2:N,2:N,6)=f((1:N-1),(1:N-1),6);
    
    f(1:N-1,2:N,7)=f(2:N,1:N-1,7);
    
    f(1:N-1,1:N-1,8)=f(2:N,2:N,8);
    
    f(2:N,1:N-1,9)=f(1:N-1,2:N,9);
   
    % Calculate equilibrium distribution

    for i=1:9

        feq(:,:,i) = w(i)*rho.*(1+3*(e(i,1)*u+e(i,2)*v)/c+4.5*(e(i,1)*u+e(i,2)*v).^2/c^2-1.5*(u.^2+v.^2)/c^2);
    
    end
%     feq(:,:,1)=w(1)*rho.*(1+3*(e(1,1)*u+e(1,2)*v)/c+4.5*(e(1,1)*u+e(1,2)*v).^2/c^2-1.5*(u.^2+v.^2)/c^2);
%     
%     feq(:,:,2)=w(2)*rho.*(1+3*(e(2,1)*u+e(2,2)*v)/c+4.5*(e(2,1)*u+e(2,2)*v).^2/c^2-1.5*(u.^2+v.^2)/c^2);
%     
%     feq(:,:,3)=w(3)*rho.*(1+3*(e(3,1)*u+e(3,2)*v)/c+4.5*(e(3,1)*u+e(3,2)*v).^2/c^2-1.5*(u.^2+v.^2)/c^2);
%     
%     feq(:,:,4)=w(4)*rho.*(1+3*(e(4,1)*u+e(4,2)*v)/c+4.5*(e(4,1)*u+e(4,2)*v).^2/c^2-1.5*(u.^2+v.^2)/c^2);
%     
%     feq(:,:,5)=w(5)*rho.*(1+3*(e(5,1)*u+e(5,2)*v)/c+4.5*(e(5,1)*u+e(5,2)*v).^2/c^2-1.5*(u.^2+v.^2)/c^2);
%     
%     feq(:,:,6)=w(6)*rho.*(1+3*(e(6,1)*u+e(6,2)*v)/c+4.5*(e(6,1)*u+e(6,2)*v).^2/c^2-1.5*(u.^2+v.^2)/c^2);
%     
%     feq(:,:,7)=w(7)*rho.*(1+3*(e(7,1)*u+e(7,2)*v)/c+4.5*(e(7,1)*u+e(7,2)*v).^2/c^2-1.5*(u.^2+v.^2)/c^2);
%     
%     feq(:,:,8)=w(8)*rho.*(1+3*(e(8,1)*u+e(8,2)*v)/c+4.5*(e(8,1)*u+e(8,2)*v).^2/c^2-1.5*(u.^2+v.^2)/c^2);
%     
%     feq(:,:,9)=w(9)*rho.*(1+3*(e(9,1)*u+e(9,2)*v)/c+4.5*(e(9,1)*u+e(9,2)*v).^2/c^2-1.5*(u.^2+v.^2)/c^2);
%     
    
    % Adjust f for colission

    f=f-(1/tau)*(f-feq);
    
    %Reflective boundary conditions

    % bottom
    f(1,:,6)=f(1,:,8);
    f(1,:,2)=f(1,:,4);
    f(1,:,9)=f(1,:,7);

    % left
    f(N,:,5)=f(N,:,6);
    f(N,:,1)=f(N,:,3);
    f(N,:,8)=f(N,:,7);
    
    %right
    f(:,1,7)=f(:,1,9);
    f(:,1,3)=f(:,1,5);
    f(:,1,6)=f(:,1,8);
    
    % Calculate density
    rho=sum(f,3);
    
    rho(1,:)=(1/(1-u0))*(f(1,:,1)+f(1,:,2)+f(1,:,4)+2*(f(1,:,3)+f(1,:,6)+f(1,:,7)));

    f(1,:,5)=f(1,:,3)+(2/3)*rho(1,:)*u0;
    f(1,:,9)=f(1,:,7)-0.5*(f(1,:,2)-f(1,:,4))+0.5*rho(1,:)*u0;
    f(1,:,7)=f(1,:,6)+0.5*(f(1,:,2)-f(1,:,4))-0.5*rho(1,:)*u0;
    
    
     
    % Calculate velocity
    u=(c./rho).*(e(2,1).*f(:,:,2)+e(3,1)*f(:,:,3)+e(4,1)*f(:,:,4)+e(5,1)*f(:,:,5)+e(6,1)*f(:,:,6)+e(7,1)*f(:,:,7)+e(8,1)*f(:,:,8)+e(9,1)*f(:,:,9));
    
    v=(c./rho).*(e(2,2).*f(:,:,2)+e(3,2)*f(:,:,3)+e(4,2)*f(:,:,4)+e(5,2)*f(:,:,5)+e(6,2)*f(:,:,6)+e(7,2)*f(:,:,7)+e(8,2)*f(:,:,8)+e(9,2)*f(:,:,9));

    if mod(step, 200) == 0
        % Plot velocity
        pcolor(xx,yy, 0.5*(u.^2+v.^2))
        h = streamslice(xx,yy,u,v,1);
        set( h, 'Color', [1,1,1] ) % or set( h, 'Color', 'k' ) if you prefer

        xlabel("$x$",'Interpreter','latex')
        ylabel("$y$",'Interpreter','latex')
        xlim([0 1])
        ylim([0 1])
        %hold on
        
        shading interp
        colormap(hot)
        title("Re = "+ num2str(Re) +" | Time = " + num2str(t))
        
        colorbar
        %hold off
        exportgraphics(gcf,"Flow "+ num2str(Re) +".gif",'Append',true);

        drawnow
    end  
        t = t + dt;
        step = step + 1;
end
    