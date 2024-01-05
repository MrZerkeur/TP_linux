FROM python
RUN apt update -y
COPY server_modified.py .
ENV CALC_PORT=13337
EXPOSE 13337
ENTRYPOINT [ "python3", "server_modified.py"]