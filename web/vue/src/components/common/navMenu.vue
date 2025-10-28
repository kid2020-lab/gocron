<template>
  <div v-cloak class="nav-container">
    <el-menu
      :default-active="currentRoute"
      mode="horizontal"
      background-color="#545c64"
      text-color="#fff"
      active-text-color="#ffd04b"
      router>
      <el-menu-item index="/task">任务管理</el-menu-item>
      <el-menu-item index="/host">任务节点</el-menu-item>
      <el-menu-item v-if="userStore.isAdmin" index="/user">用户管理</el-menu-item>
      <el-menu-item v-if="userStore.isAdmin" index="/system">系统管理</el-menu-item>
    </el-menu>
    <div v-if="userStore.isLogin" class="user-menu">
      <el-dropdown trigger="click">
        <span class="user-info">
          <el-icon><User /></el-icon>
          <span>{{ userStore.username || '用户' }}</span>
          <el-icon><ArrowDown /></el-icon>
        </span>
        <template #dropdown>
          <el-dropdown-menu>
            <el-dropdown-item @click="$router.push('/user/edit-my-password')">修改密码</el-dropdown-item>
            <el-dropdown-item @click="$router.push('/user/two-factor')">双因素认证</el-dropdown-item>
            <el-dropdown-item divided @click="logout">退出</el-dropdown-item>
          </el-dropdown-menu>
        </template>
      </el-dropdown>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useUserStore } from '../../stores/user'
import { ArrowDown, User } from '@element-plus/icons-vue'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

const currentRoute = computed(() => {
  if (route.path === '/') return '/task'
  const segments = route.path.split('/')
  return `/${segments[1]}`
})

const logout = () => {
  userStore.logout()
  router.push('/user/login').then(() => {
    window.location.reload()
  })
}
</script>

<style scoped>
.nav-container {
  display: flex;
  align-items: center;
  background-color: #545c64;
}
.el-menu {
  flex: 1;
  border: none;
}
.user-menu {
  padding: 0 20px;
}
.user-info {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #fff;
  cursor: pointer;
  padding: 10px;
  border-radius: 4px;
  transition: background-color 0.3s;
}
.user-info:hover {
  background-color: rgba(255, 255, 255, 0.1);
}
</style>