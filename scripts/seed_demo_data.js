// SprintFlow Demo Data Seeding Script
// Populates Authentication accounts and rich Firestore data for Manager, Employee, and Client dashboards.

const API_KEY = 'AIzaSyCUhq7P5Mt4-aJmN5tMSo9pxyMzJJxGf88';
const PROJECT_ID = 'flowforge-a21d8';
const FIRESTORE_BASE = `https://firestore.googleapis.com/v1/projects/${PROJECT_ID}/databases/(default)/documents`;

function toFirestoreValue(val) {
  if (val === null || val === undefined) return { nullValue: null };
  if (typeof val === 'string') return { stringValue: val };
  if (typeof val === 'boolean') return { booleanValue: val };
  if (typeof val === 'number') {
    if (Number.isInteger(val)) return { integerValue: String(val) };
    return { doubleValue: val };
  }
  if (val instanceof Date) return { timestampValue: val.toISOString() };
  if (Array.isArray(val)) {
    return { arrayValue: { values: val.map(toFirestoreValue) } };
  }
  if (typeof val === 'object') {
    if (val._isTimestamp) return { timestampValue: val.value };
    const fields = {};
    for (const [k, v] of Object.entries(val)) {
      fields[k] = toFirestoreValue(v);
    }
    return { mapValue: { fields } };
  }
  return { stringValue: String(val) };
}

function toFirestoreFields(obj) {
  const fields = {};
  for (const [k, v] of Object.entries(obj)) {
    fields[k] = toFirestoreValue(v);
  }
  return { fields };
}

async function getOrCreateUser(email, password) {
  // Try login first
  const loginRes = await fetch(`https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${API_KEY}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email, password, returnSecureToken: true }),
  });
  const loginData = await loginRes.json();
  if (!loginData.error) {
    return { uid: loginData.localId, idToken: loginData.idToken };
  }

  // If not found, sign up
  const signupRes = await fetch(`https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${API_KEY}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email, password, returnSecureToken: true }),
  });
  const signupData = await signupRes.json();
  if (signupData.error) {
    throw new Error(`Failed to create user ${email}: ${signupData.error.message}`);
  }
  return { uid: signupData.localId, idToken: signupData.idToken };
}

async function setDoc(token, collection, docId, data) {
  const url = `${FIRESTORE_BASE}/${collection}/${docId}`;
  const res = await fetch(url, {
    method: 'PATCH',
    headers: {
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(toFirestoreFields(data)),
  });
  if (!res.ok) {
    const err = await res.text();
    console.error(`Error saving ${collection}/${docId}:`, err);
    throw new Error(`Firestore save failed for ${collection}/${docId}`);
  }
  return await res.json();
}

async function seed() {
  console.log('--- Starting SprintFlow Demo Data Seeding ---');

  // 1. Create Demo Users
  console.log('1. Setting up Authentication Accounts...');
  const manager = await getOrCreateUser('manager@sprintflow.com', 'Password123!');
  console.log(`   Manager: manager@sprintflow.com (UID: ${manager.uid})`);

  const employee = await getOrCreateUser('employee@sprintflow.com', 'Password123!');
  console.log(`   Employee: employee@sprintflow.com (UID: ${employee.uid})`);

  const client = await getOrCreateUser('client@sprintflow.com', 'Password123!');
  console.log(`   Client: client@sprintflow.com (UID: ${client.uid})`);

  const authToken = manager.idToken;
  const now = new Date();
  const pastDays = (d) => new Date(now.getTime() - d * 24 * 60 * 60 * 1000);
  const futureDays = (d) => new Date(now.getTime() + d * 24 * 60 * 60 * 1000);

  // Project IDs
  const proj1Id = 'proj-fintech-banking';
  const proj2Id = 'proj-cloud-migration';
  const proj3Id = 'proj-ai-analytics';

  // 2. Seed User Profiles
  console.log('2. Populating User Profiles in Firestore...');
  await setDoc(authToken, 'managers', manager.uid, {
    email: 'manager@sprintflow.com',
    name: 'Alex Morgan',
    role: 'manager',
    department: 'Engineering & Agile Delivery',
    position: 'Director of Product Engineering',
    phone: '+1 (555) 019-2834',
    bio: 'Agile enthusiast leading sprint teams building modern cloud & mobile applications.',
    createdAt: pastDays(90),
    isActive: true,
    isOnline: true,
    managedProjects: [proj1Id, proj2Id, proj3Id],
    managedEmployees: [employee.uid],
    managedClients: [client.uid],
  });

  await setDoc(authToken, 'employees', employee.uid, {
    email: 'employee@sprintflow.com',
    name: 'Sarah Chen',
    role: 'employee',
    managerId: manager.uid,
    department: 'Mobile & Cloud Systems',
    position: 'Senior Full Stack Engineer',
    phone: '+1 (555) 782-9014',
    bio: 'Flutter and Cloud specialist focused on resilient, high-performance architecture.',
    hireDate: pastDays(365),
    performanceRating: 4.9,
    createdAt: pastDays(60),
    isActive: true,
    isOnline: true,
    assignedProjects: [proj1Id, proj2Id],
  });

  await setDoc(authToken, 'clients', client.uid, {
    email: 'client@sprintflow.com',
    name: 'David Miller',
    role: 'client',
    companyName: 'Apex Capital Global',
    contactPerson: 'David Miller (VP of Product Strategy)',
    phone: '+1 (555) 438-9921',
    createdAt: pastDays(60),
    isActive: true,
    isOnline: false,
    clientProjects: [proj1Id, proj2Id],
    activeClients: [client.uid],
  });

  // 3. Seed Projects
  console.log('3. Populating Projects & Client Mirrors...');
  const p1 = {
    title: 'FinTech Mobile Banking 2.0',
    description: 'Next-gen biometric mobile banking application with real-time portfolio management, instant P2P payments, and multi-currency transactions.',
    status: 'in_progress',
    managerId: manager.uid,
    clientId: client.uid,
    clientEmail: 'client@sprintflow.com',
    createdAt: pastDays(30),
    expectedFinish: futureDays(21),
    assignedEmployees: [employee.uid],
    progressPercentage: 75.0,
    totalTasks: 8,
    completedTasks: 6,
    overdueTasks: 0,
    isPublic: true,
    isArchived: false,
    tags: ['FinTech', 'Mobile', 'Security', 'Flutter'],
  };
  await setDoc(authToken, 'managers_projects', proj1Id, p1);
  await setDoc(authToken, 'clients_projects', proj1Id, {
    id: proj1Id,
    title: p1.title,
    description: p1.description,
    clientId: client.uid,
    clientEmail: 'client@sprintflow.com',
    clientKeys: [client.uid, 'client@sprintflow.com'],
    managerId: manager.uid,
    createdAt: p1.createdAt,
    expectedFinish: p1.expectedFinish,
    progressPercentage: 75.0,
    totalTasks: 8,
    completedTasks: 6,
    overdueTasks: 0,
    status: 'in_progress',
  });

  const p2 = {
    title: 'Cloud Microservices Migration',
    description: 'Decomposing monolithic legacy backend into event-driven Kubernetes microservices with zero-downtime CI/CD pipelines.',
    status: 'in_progress',
    managerId: manager.uid,
    clientId: client.uid,
    clientEmail: 'client@sprintflow.com',
    createdAt: pastDays(45),
    expectedFinish: futureDays(42),
    assignedEmployees: [employee.uid],
    progressPercentage: 45.0,
    totalTasks: 6,
    completedTasks: 2,
    overdueTasks: 1,
    isPublic: true,
    isArchived: false,
    tags: ['Cloud', 'Kubernetes', 'DevOps'],
  };
  await setDoc(authToken, 'managers_projects', proj2Id, p2);
  await setDoc(authToken, 'clients_projects', proj2Id, {
    id: proj2Id,
    title: p2.title,
    description: p2.description,
    clientId: client.uid,
    clientEmail: 'client@sprintflow.com',
    clientKeys: [client.uid, 'client@sprintflow.com'],
    managerId: manager.uid,
    createdAt: p2.createdAt,
    expectedFinish: p2.expectedFinish,
    progressPercentage: 45.0,
    totalTasks: 6,
    completedTasks: 2,
    overdueTasks: 1,
    status: 'in_progress',
  });

  const p3 = {
    title: 'AI Sprint Analytics Dashboard',
    description: 'Predictive sprint velocity modeling and team bottleneck detection powered by machine learning algorithms.',
    status: 'draft',
    managerId: manager.uid,
    clientId: '',
    createdAt: pastDays(10),
    expectedFinish: futureDays(60),
    assignedEmployees: [],
    progressPercentage: 15.0,
    totalTasks: 4,
    completedTasks: 0,
    overdueTasks: 0,
    isPublic: true,
    isArchived: false,
    tags: ['AI/ML', 'Analytics', 'Internal'],
  };
  await setDoc(authToken, 'managers_projects', proj3Id, p3);

  // 4. Seed Tasks
  console.log('4. Populating Tasks for Projects and Employee...');
  const tasks = [
    {
      id: 'task-biometric-auth',
      title: 'Biometric Authentication & Keychain Storage',
      description: 'Integrated FaceID and Fingerprint biometric authentication with secure hardware-backed enclave key storage.',
      status: 'done',
      priority: 'critical',
      projectId: proj1Id,
      assignedTo: employee.uid,
      createdBy: manager.uid,
      createdAt: pastDays(15),
      deadline: pastDays(2),
      completedAt: pastDays(2),
      progressPercentage: 100.0,
      estimatedHours: 16,
      actualHours: 14,
      subtasks: [
        { id: 'sub-1', title: 'Design biometric fallback PIN screen', isCompleted: true },
        { id: 'sub-2', title: 'Implement local_auth hardware channel', isCompleted: true },
        { id: 'sub-3', title: 'Write security enclave encryption tests', isCompleted: true },
      ],
      tags: ['Security', 'Auth', 'Mobile'],
    },
    {
      id: 'task-payment-gateway',
      title: 'Stripe & Plaid Payment Gateway Integration',
      description: 'Implement real-time instant bank transfers, secure tokenization, and webhook reconciliation endpoints.',
      status: 'in_progress',
      priority: 'high',
      projectId: proj1Id,
      assignedTo: employee.uid,
      createdBy: manager.uid,
      createdAt: pastDays(10),
      deadline: futureDays(3),
      progressPercentage: 75.0,
      estimatedHours: 20,
      actualHours: 15,
      subtasks: [
        { id: 'sub-4', title: 'Configure Plaid Link token exchange', isCompleted: true },
        { id: 'sub-5', title: 'Implement idempotency key middleware', isCompleted: true },
        { id: 'sub-6', title: 'Realtime webhook signature verification', isCompleted: false },
        { id: 'sub-7', title: 'Handle insufficient funds exception UI', isCompleted: false },
      ],
      tags: ['FinTech', 'API', 'Payments'],
    },
    {
      id: 'task-firestore-cache',
      title: 'Optimize Firestore Queries & Offline Caching',
      description: 'Refactor composite indexes and enable offline persistence cache for real-time task sync under poor connectivity.',
      status: 'in_progress',
      priority: 'medium',
      projectId: proj1Id,
      assignedTo: employee.uid,
      createdBy: manager.uid,
      createdAt: pastDays(5),
      deadline: futureDays(6),
      progressPercentage: 40.0,
      estimatedHours: 12,
      actualHours: 5,
      subtasks: [
        { id: 'sub-8', title: 'Review compound query index latency', isCompleted: true },
        { id: 'sub-9', title: 'Add local cache fallback on network drop', isCompleted: false },
      ],
      tags: ['Database', 'Optimization'],
    },
    {
      id: 'task-e2e-testing',
      title: 'End-to-End Automated Integration Testing',
      description: 'Set up full scenario smoke tests covering client onboarding, sprint creation, and role authorization.',
      status: 'todo',
      priority: 'medium',
      projectId: proj1Id,
      assignedTo: employee.uid,
      createdBy: manager.uid,
      createdAt: pastDays(2),
      deadline: futureDays(12),
      progressPercentage: 0.0,
      estimatedHours: 15,
      actualHours: 0,
      subtasks: [
        { id: 'sub-10', title: 'Write user registration flow tests', isCompleted: false },
        { id: 'sub-11', title: 'Write role-based dashboard navigation tests', isCompleted: false },
      ],
      tags: ['Testing', 'CI/CD'],
    },
    {
      id: 'task-soc2-compliance',
      title: 'Regulatory SOC-2 Compliance Audit Checklist',
      description: 'Complete data retention policy review and configure audit access logging for sensitive client endpoints.',
      status: 'overdue',
      priority: 'critical',
      projectId: proj2Id,
      assignedTo: employee.uid,
      createdBy: manager.uid,
      createdAt: pastDays(20),
      deadline: pastDays(2), // Overdue!
      progressPercentage: 30.0,
      estimatedHours: 10,
      actualHours: 4,
      subtasks: [
        { id: 'sub-12', title: 'Draft data retention document', isCompleted: true },
        { id: 'sub-13', title: 'Implement audit trail logging interceptor', isCompleted: false },
      ],
      tags: ['Compliance', 'Security'],
    },
  ];

  for (const t of tasks) {
    await setDoc(authToken, 'managers_tasks', t.id, t);
    await setDoc(authToken, 'employees_tasks', t.id, t);
  }

  // 5. Seed Work Updates (Powers the Weekly Work Hours Chart)
  console.log('5. Populating Weekly Work Updates for Analytics Chart...');
  const workUpdates = [
    {
      id: 'update-mon',
      taskId: 'task-biometric-auth',
      employeeId: employee.uid,
      projectId: proj1Id,
      update: 'Completed biometric auth channel tests and hardware enclave key storage.',
      workHours: 7,
      progressPercentage: 100,
      createdAt: pastDays(4),
    },
    {
      id: 'update-tue',
      taskId: 'task-payment-gateway',
      employeeId: employee.uid,
      projectId: proj1Id,
      update: 'Configured Plaid link API and secure token exchange pipeline.',
      workHours: 8,
      progressPercentage: 40,
      createdAt: pastDays(3),
    },
    {
      id: 'update-wed',
      taskId: 'task-payment-gateway',
      employeeId: employee.uid,
      projectId: proj1Id,
      update: 'Implemented idempotency keys and transactional webhook listeners.',
      workHours: 6,
      progressPercentage: 65,
      createdAt: pastDays(2),
    },
    {
      id: 'update-thu',
      taskId: 'task-firestore-cache',
      employeeId: employee.uid,
      projectId: proj1Id,
      update: 'Refactored composite query indexes and tested offline stream recovery.',
      workHours: 8,
      progressPercentage: 40,
      createdAt: pastDays(1),
    },
    {
      id: 'update-fri',
      taskId: 'task-payment-gateway',
      employeeId: employee.uid,
      projectId: proj1Id,
      update: 'Wrapped webhook signature verification and tested edge cases.',
      workHours: 7,
      progressPercentage: 75,
      createdAt: now,
    },
  ];

  for (const u of workUpdates) {
    await setDoc(authToken, 'work_updates', u.id, u);
  }

  // 6. Seed Manager Updates (Client feed)
  console.log('6. Populating Manager Updates for Client Feed...');
  const managerUpdates = [
    {
      id: 'mgr-update-1',
      projectId: proj1Id,
      clientId: client.uid,
      managerId: manager.uid,
      title: 'Sprint 4 Milestone Achieved: Biometrics & Core Payments',
      message: 'Sprint 4 has completed ahead of schedule. Biometric security is fully verified and payment gateway tests have reached 98% coverage.',
      createdAt: pastDays(2),
    },
    {
      id: 'mgr-update-2',
      projectId: proj1Id,
      clientId: client.uid,
      managerId: manager.uid,
      title: 'Architecture Review & Security Benchmark Passed',
      message: 'Completed second-stage security benchmark with zero high-vulnerability findings. Project remains on track for the target launch date.',
      createdAt: pastDays(5),
    },
    {
      id: 'mgr-update-3',
      projectId: proj2Id,
      clientId: client.uid,
      managerId: manager.uid,
      title: 'Cloud Migration Sprint 2 In Progress',
      message: 'Microservices cluster provisioned in staging. Kubernetes ingress and SSL certificate automation completed successfully.',
      createdAt: pastDays(8),
    },
  ];

  for (const mu of managerUpdates) {
    await setDoc(authToken, 'manager_updates', mu.id, mu);
  }

  console.log('--- Seeding Completed Successfully! ---');
}

seed().catch((err) => {
  console.error('Seeding failed:', err);
  process.exit(1);
});
