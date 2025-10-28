<template>
  <el-container>
    <system-sidebar></system-sidebar>
    <el-main>
      <h3>日志自动清理设置</h3>
      <el-form :model="form" label-width="180px" style="width: 600px;">
        <el-form-item label="数据库日志保留天数">
          <el-input-number v-model="form.days" :min="0" :max="3650" style="width: 200px;"></el-input-number>
          <div style="color: #909399; font-size: 12px; margin-top: 5px;">
            设置为0表示不自动清理数据库日志
          </div>
        </el-form-item>
        <el-form-item label="清理时间">
          <el-time-picker
            v-model="cleanupTime"
            format="HH:mm"
            value-format="HH:mm"
            placeholder="选择时间"
            style="width: 200px;">
          </el-time-picker>
          <div style="color: #909399; font-size: 12px; margin-top: 5px;">
            每天在此时间自动执行日志清理，修改后立即生效
          </div>
        </el-form-item>
        <el-form-item label="日志文件大小限制">
          <el-input-number v-model="form.fileSizeLimit" :min="0" :max="10240" style="width: 200px;"></el-input-number>
          <span style="margin-left: 10px;">MB</span>
          <div style="color: #909399; font-size: 12px; margin-top: 5px;">
            设置为0表示不清理日志文件，大于0则当日志文件超过此大小时自动清空
          </div>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="submit">保存</el-button>
        </el-form-item>
      </el-form>
    </el-main>
  </el-container>
</template>

<script>
import systemSidebar from './sidebar.vue'
import httpClient from '../../utils/httpClient'

export default {
  name: 'log-retention',
  components: { systemSidebar },
  data() {
    return {
      form: {
        days: 0,
        fileSizeLimit: 0
      },
      cleanupTime: '03:00'
    }
  },
  created() {
    this.loadData()
  },
  methods: {
    loadData() {
      httpClient.get('/system/log-retention', {}, (data) => {
        this.form.days = data.days
        this.form.fileSizeLimit = data.file_size_limit || 0
        this.cleanupTime = data.cleanup_time || '03:00'
      })
    },
    submit() {
      httpClient.postJson('/system/log-retention', { 
        days: this.form.days,
        cleanup_time: this.cleanupTime,
        file_size_limit: this.form.fileSizeLimit
      }, () => {
        this.$message.success('保存成功，清理任务已重新加载')
      })
    }
  }
}
</script>
