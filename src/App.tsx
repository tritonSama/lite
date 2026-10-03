import React, { useState } from 'react';
import { AppProvider, useApp } from './context/AppContext';
import { Header } from './components/Header';
import { BottomNav, NavTab } from './components/BottomNav';
import { CommsDrawer } from './components/CommsDrawer';
import { NotificationsModal } from './components/NotificationsModal';
import { CreateTaskModal } from './components/CreateTaskModal';
import { MakeOfferModal } from './components/MakeOfferModal';
import { TaskDetailModal } from './components/TaskDetailModal';
import { TaskVerificationModal } from './components/TaskVerificationModal';

import { BoardPage } from './pages/BoardPage';
import { GamePage } from './pages/GamePage';
import { MissionControlPage } from './pages/MissionControlPage';
import { TeamsPage } from './pages/TeamsPage';
import { ConstellationPage } from './pages/ConstellationPage';
import { ProfilePage } from './pages/ProfilePage';
import { NexusPage } from './pages/NexusPage';
import { BidsPage } from './pages/BidsPage';
import { ObdPage } from './pages/ObdPage';
import { CreateEventModal } from './components/CreateEventModal';

import { Task } from './types';

const MainLayout: React.FC = () => {
  const { isDarkMode, isCommsOpen, openComms, closeComms } = useApp();
  const [activeTab, setActiveTab] = useState<NavTab>('board');
  const [activeSubView, setActiveSubView] = useState<'none' | 'constellation' | 'bids' | 'obd'>('none');

  // Modals & Drawers
  const [isNotificationsOpen, setIsNotificationsOpen] = useState(false);
  const [isCreateTaskOpen, setIsCreateTaskOpen] = useState(false);
  const [isCreateEventOpen, setIsCreateEventOpen] = useState(false);

  // Task-specific modals
  const [selectedTaskForOffer, setSelectedTaskForOffer] = useState<Task | null>(null);
  const [selectedTaskForDetail, setSelectedTaskForDetail] = useState<Task | null>(null);
  const [selectedTaskForVerify, setSelectedTaskForVerify] = useState<Task | null>(null);

  const handleTabChange = (tab: NavTab) => {
    setActiveTab(tab);
    setActiveSubView('none'); // Return to root of tab
  };

  const renderContent = () => {
    // Check subviews first
    if (activeSubView === 'constellation') {
      return <ConstellationPage onBack={() => setActiveSubView('none')} />;
    }
    if (activeSubView === 'bids') {
      return <BidsPage onBack={() => setActiveSubView('none')} />;
    }
    if (activeSubView === 'obd') {
      return <ObdPage onBack={() => setActiveSubView('none')} />;
    }

    // Main tabs
    switch (activeTab) {
      case 'board':
        return (
          <BoardPage
            onOpenCreateTask={() => setIsCreateTaskOpen(true)}
            onOpenCreateEvent={() => setIsCreateEventOpen(true)}
            onOpenMakeOffer={task => setSelectedTaskForOffer(task)}
            onOpenTaskDetail={task => setSelectedTaskForDetail(task)}
            onOpenVerify={task => setSelectedTaskForVerify(task)}
          />
        );
      case 'game':
        return <GamePage />;
      case 'mission':
        return (
          <MissionControlPage
            onOpenComms={() => openComms('radio')}
            onOpenTeams={() => handleTabChange('teams')}
            onOpenWars={() => {
              handleTabChange('teams');
            }}
            onOpenObd={() => setActiveSubView('obd')}
          />
        );
      case 'teams':
        return (
          <TeamsPage
            onOpenConstellation={() => handleTabChange('mission')}
          />
        );
      case 'profile':
        return <ProfilePage />;
      case 'nexus':
        return <NexusPage />;
      default:
        return null;
    }
  };

  return (
    <div className={`min-h-screen flex flex-col font-sans transition-colors duration-200 ${
      isDarkMode ? 'bg-[#0C0F1D] text-[#E9EDF2]' : 'bg-[#F4F6FB] text-slate-900'
    }`}>
      {/* Top Header */}
      <Header
        onOpenComms={() => openComms('radio')}
        onOpenNotifications={() => setIsNotificationsOpen(true)}
        onOpenCreateTask={() => setIsCreateTaskOpen(true)}
        onOpenCreateEvent={() => setIsCreateEventOpen(true)}
      />

      {/* Main Content Area */}
      <main className="flex-1 w-full">
        {renderContent()}
      </main>

      {/* Bottom Navigation */}
      <BottomNav
        activeTab={activeTab}
        onChangeTab={handleTabChange}
      />

      {/* Overlays / Modals / Drawers */}
      <CommsDrawer
        isOpen={isCommsOpen}
        onClose={closeComms}
      />

      <NotificationsModal
        isOpen={isNotificationsOpen}
        onClose={() => setIsNotificationsOpen(false)}
      />

      <CreateTaskModal
        isOpen={isCreateTaskOpen}
        onClose={() => setIsCreateTaskOpen(false)}
      />

      <CreateEventModal
        isOpen={isCreateEventOpen}
        onClose={() => setIsCreateEventOpen(false)}
      />

      <MakeOfferModal
        task={selectedTaskForOffer}
        isOpen={selectedTaskForOffer !== null}
        onClose={() => setSelectedTaskForOffer(null)}
      />

      <TaskDetailModal
        task={selectedTaskForDetail}
        isOpen={selectedTaskForDetail !== null}
        onClose={() => setSelectedTaskForDetail(null)}
        onOpenMakeOffer={task => setSelectedTaskForOffer(task)}
        onOpenVerify={task => setSelectedTaskForVerify(task)}
      />

      <TaskVerificationModal
        task={selectedTaskForVerify}
        isOpen={selectedTaskForVerify !== null}
        onClose={() => setSelectedTaskForVerify(null)}
      />
    </div>
  );
};

export const App: React.FC = () => {
  return (
    <AppProvider>
      <MainLayout />
    </AppProvider>
  );
};

export default App;
