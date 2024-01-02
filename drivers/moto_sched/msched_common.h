/*
 * Copyright (C) 2023 Motorola Mobility LLC
 *
 * This software is licensed under the terms of the GNU General Public
 * License version 2, as published by the Free Software Foundation, and
 * may be copied, distributed, and modified under those terms.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 */


#ifndef _MOTO_SCHED_COMMON_H_
#define _MOTO_SCHED_COMMON_H_

#include <linux/sched.h>
#include <linux/list.h>
#include <linux/types.h>
#include <linux/atomic.h>
#include <linux/hashtable.h>
#if IS_ENABLED(CONFIG_SCHED_WALT)
#include <linux/sched/walt.h>
#endif


#define sched_err(fmt, ...) \
		pr_err("[moto_sched][%s]"fmt, __func__, ##__VA_ARGS__)
#define sched_warn(fmt, ...) \
		pr_warn("[moto_sched][%s]"fmt, __func__, ##__VA_ARGS__)
#define sched_debug(fmt, ...) \
		pr_info("[moto_sched][%s]"fmt, __func__, ##__VA_ARGS__)


/* define for UX thread type, keep same as the define in java file */
#define UX_TYPE_PERF_DAEMON			(1 << 0)
#define UX_TYPE_AUDIO				(1 << 1)
#define UX_TYPE_INPUT				(1 << 2)
#define UX_TYPE_ANIMATOR			(1 << 3)
#define UX_TYPE_TOPAPP				(1 << 4)
#define UX_TYPE_TOPUI				(1 << 5)
#define UX_TYPE_LAUNCHER			(1 << 6)
#define UX_TYPE_KSWAPD				(1 << 7)
#define UX_TYPE_SYSTEM				(1 << 8)
#define UX_TYPE_INHERIT_HIGH		(1 << 9)
#define UX_TYPE_INHERIT_LOW			(1 << 10)
#define UX_TYPE_GESTURE_MONITOR		(1 << 11)
#define UX_TYPE_SF					(1 << 12)
#define UX_TYPE_AUDIOSERVICE		(1 << 13)
#define UX_TYPE_AUDIOAPP			(1 << 14)

/* define for UX scene type, keep same as the define in java file */
#define UX_SCENE_LAUNCH				(1 << 0)
#define UX_SCENE_TOUCH				(1 << 1)
#define UX_SCENE_AUDIO				(1 << 2)

/* define for MVP priority, the higher the better, should be in the range (11~100) */
#define UX_PRIO_HIGHEST		100

#define UX_PRIO_URGENT_AUDIO 80
#define UX_PRIO_AUDIO		79
#define UX_PRIO_INPUT		78

#define UX_PRIO_TOPAPP		70 // must be aligned with walt.h!
#define UX_PRIO_ANIMATOR	69
#define UX_PRIO_ANIMATOR_LOW 68
#define UX_PRIO_TOPUI		67
#define UX_PRIO_LAUNCHER	66
#define UX_PRIO_GESTURE_MONITOR	65

#define UX_PRIO_OTHER_HIGH	60 // mvp 60~41 = cfs 100~119
#define UX_PRIO_KSWAPD		35
#define UX_PRIO_OTHER_LOW	30 // mvp 30~11 = cfs 120~139

#define UX_PRIO_LOWEST		11
#define UX_PRIO_INVALID		-1

/* global vars and functions */
extern int __read_mostly moto_sched_enabled;
extern int __read_mostly moto_sched_scene;
extern int __read_mostly moto_boost_prio;

extern int task_get_mvp_prio(struct task_struct *p, bool with_inherit);
extern unsigned int task_get_mvp_limit(int mvp_prio);
extern void binder_inherit_ux_type(struct task_struct *task);
extern void binder_clear_inherited_ux_type(struct task_struct *task);
extern void binder_ux_type_set(struct task_struct *task, bool has_clear, bool clear);

static inline int task_get_ux_type(struct task_struct *p)
{
#if IS_ENABLED(CONFIG_SCHED_WALT)
	struct walt_task_struct *wts = (struct walt_task_struct *) p->android_vendor_data1;
	return wts->ux_type;
#else
	return 0; // todo: implement it on mtk platform.
#endif
}

static inline void task_add_ux_type(struct task_struct *p, int type)
{
#if IS_ENABLED(CONFIG_SCHED_WALT)
	struct walt_task_struct *wts = (struct walt_task_struct *) p->android_vendor_data1;
	wts->ux_type |= type;
#else
	// todo: implement it on mtk platform.
#endif
}

static inline void task_clr_ux_type(struct task_struct *p, int type)
{
#if IS_ENABLED(CONFIG_SCHED_WALT)
	struct walt_task_struct *wts = (struct walt_task_struct *) p->android_vendor_data1;
	wts->ux_type &= ~type;
#else
	// todo: implement it on mtk platform.
#endif
}

#endif /* _MOTO_SCHED_COMMON_H_ */
