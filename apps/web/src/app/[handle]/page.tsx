import React from "react";
import { MessageComposer } from "../../components/MessageComposer";
import Link from "next/link";
import { ArrowLeft } from "lucide-react";

interface PageProps {
  params: Promise<{
    handle: string;
  }>;
}

export default async function HandlePage({ params }: PageProps) {
  const resolvedParams = await params;
  const handle = decodeURIComponent(resolvedParams.handle);

  return (
    <div className="w-full max-w-xl mx-auto space-y-4 py-4">
      {/* Back button */}
      <div className="flex items-center justify-between px-2">
        <Link
          href="/"
          className="inline-flex items-center gap-1.5 text-xs text-neutral-400 hover:text-white transition-colors"
        >
          <ArrowLeft className="w-3.5 h-3.5" />
          <span>Voltar para o início</span>
        </Link>
        <span className="text-[11px] font-mono text-neutral-500">
          heeey.live/{handle}
        </span>
      </div>

      {/* Message Composer Component */}
      <MessageComposer targetHandle={handle} />
    </div>
  );
}
