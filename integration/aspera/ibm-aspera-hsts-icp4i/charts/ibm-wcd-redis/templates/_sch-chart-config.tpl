{{- define "ibm-wcd-redis.sch.chart.config.values" }}
sch:
  chart:
    appName: "redis-ha"
    components:
      server: "server"
      sentinel: "sentinel"
      test: "test"
      master: "master"
      slave: "slave"
    metering:
      productID: RedisHA_406r0_free_00000
      productName: Redis HA
      productVersion: 3.2.12-r0
{{- end -}}
