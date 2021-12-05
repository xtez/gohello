FROM golang:1.17.4 as builder
ARG app=foo
RUN echo ${app}
WORKDIR /src
COPY . .
RUN CGO_ENABLED=0 go build -o ${app}

FROM alpine:3.15.0
ARG app=foo
ENV BINARY=${app}
COPY --from=builder /src/${app} /
EXPOSE 80
CMD [ "sh", "-c", "/${BINARY}" ]
