package Cx

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod_security_policy[name]

	object.get(resource.spec, "allowed_unsafe_sysctls", "undefined") != "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_pod_security_policy[%s].spec.allowed_unsafe_sysctls", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_pod_security_policy[%s].spec.allowed_unsafe_sysctls is undefined", [name]),
		"keyActualValue": sprintf("kubernetes_pod_security_policy[%s].spec.allowed_unsafe_sysctls is set", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]

	sysctl := resource.spec.security_context.sysctl[x].name
	check_Unsafe(sysctl)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_pod[%s].spec.security_context.sysctl", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_pod[%s].spec.security_context.sysctl[%s].name does not have an Unsafe Sysctl", [name, x]),
		"keyActualValue": sprintf("kubernetes_pod[%s].spec.security_context.sysctl[%s].name has an Unsafe Sysctl", [name, x]),
	}
}

check_Unsafe(sysctl) {
	safeSysctls = {"kernel.shm_rmid_forced", "net.ipv4.ip_local_port_range", "net.ipv4.tcp_syncookies", "net.ipv4.ping_group_range"}
	not safeSysctls[sysctl]
}
