FROM node:14-stretch AS builder
COPY . /home/node/app
WORKDIR /home/node/app
RUN ls
RUN npm install
RUN npm update
RUN npm audit fix
RUN npm run build
RUN ls

# 正式伺服器
FROM tomcat:jdk17
RUN ["rm", "-rf", "/usr/local/tomcat/webapps/*"]
WORKDIR /usr/local/tomcat/webapps
RUN mkdir myapp
RUN cd myapp
RUN ls
COPY --from=builder /home/node/app/WEB-INF/web.xml /usr/local/tomcat/conf/web.xml
COPY --from=builder /home/node/app/dist/  /usr/local/tomcat/webapps/myapp
RUN ls
#run
CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]


#"vite": "^2.9.16"
